# Karpenter requires an IAM OIDC provider for the EKS cluster.
# This is typically created by EKS itself. We use `local.oidc_provider_arn` from variables.tf.

resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
    labels = {
      name = "karpenter"
      # Required for Karpenter v0.32+ webhook to work correctly if it's configured with namespace selectors
      "karpenter.sh/webhook-enabled" = "true" 
    }
  }
}

# IAM Role for Karpenter Controller (using IAM Roles for Service Accounts - IRSA)
resource "aws_iam_role" "karpenter_controller" {
  name = "${local.cluster_name}-karpenter-controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = local.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # The :sub is the service account subject. Adjust if you change the SA name or namespace in Helm chart.
            "${replace(local.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${kubernetes_namespace.karpenter.metadata[0].name}:karpenter"
          }
        }
      },
    ]
  })
  tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }
}

resource "aws_iam_role_policy" "karpenter_controller" {
  name = "${local.cluster_name}-karpenter-controller-policy"
  role = aws_iam_role.karpenter_controller.id

  # Policy based on official Karpenter documentation. Review and adjust as necessary.
  # https://karpenter.sh/docs/getting-started/getting-started-with-terraform/#configure-iam-resources
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Karpenter"
        Effect = "Allow"
        Action = [
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateTags",
          "ec2:DeleteLaunchTemplate",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSecurityGroups", # Used for EC2NodeClass securityGroupSelector discovery
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets", # Used for EC2NodeClass subnetSelector discovery
          "ec2:RunInstances",
          # "ec2:TerminateInstances", # This is scoped down below
          "iam:PassRole",
          "iam:CreateInstanceProfile", # If Karpenter needs to create new instance profiles
          "iam:TagInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:GetInstanceProfile",
          "pricing:GetProducts",
          "ssm:GetParameter", # For AMI resolution
          "eks:DescribeCluster" # To get cluster information
        ]
        Resource = "*" # Some actions require "*"
      },
      {
        Sid      = "ConditionalTerminate" # Scope down TerminateInstances
        Effect   = "Allow"
        Action   = "ec2:TerminateInstances"
        Resource = "*"
        Condition = {
          StringLike = { "ec2:ResourceTag/karpenter.sh/nodepool": "*" } # For v0.31 and older
          # For v0.32+ NodePool was renamed to NodePool, and EC2NodeClass is used.
          # The tag key might be "karpenter.sh/nodepool" or "karpenter.sh/provisioner-name" (older versions)
          # Or "karpenter.sh/nodepool" if you tag nodes with the NodePool name.
          # For EC2NodeClass based provisioning, the tag might be on the EC2NodeClass or NodePool.
          # It's safer to ensure nodes launched by Karpenter have a distinguishing tag.
        }
      },
      # If using SQS for interruption handling (optional)
      # {
      #   Sid    = "SQSInterruption"
      #   Effect = "Allow"
      #   Action = ["sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl", "sqs:ReceiveMessage"],
      #   Resource = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:karpenter-*" # Adjust if your queue name differs
      # }
    ]
  })
}

# IAM Role for Nodes launched by Karpenter
resource "aws_iam_role" "karpenter_node" {
  name = "${local.cluster_name}-karpenter-node"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = {
    # Tag used by Karpenter for discovery if needed, and for organization
    "karpenter.sh/discovery" = local.cluster_name
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.karpenter_node.name
}

resource "aws_iam_role_policy_attachment" "karpenter_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_node.name
}

resource "aws_iam_role_policy_attachment" "karpenter_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_node.name
}

resource "aws_iam_role_policy_attachment" "karpenter_node_AmazonSSMManagedInstanceCore" {
  # Required for SSM for AMI family auto-updates and some instance types.
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.karpenter_node.name
}

# Instance Profile for Karpenter Nodes
resource "aws_iam_instance_profile" "karpenter_node" {
  name = aws_iam_role.karpenter_node.name # Karpenter expects the instance profile name to match the role name by default
  role = aws_iam_role.karpenter_node.name
  tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  namespace  = kubernetes_namespace.karpenter.metadata[0].name
  chart      = "oci://public.ecr.aws/karpenter/karpenter" # Karpenter chart is distributed via OCI
  version    = var.karpenter_chart_version

  wait          = true
  wait_for_jobs = true
  timeout       = 600 # 10 minutes

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }
  set {
    name  = "settings.aws.clusterName"
    value = local.cluster_name
  }
  set {
    name  = "settings.aws.defaultInstanceProfile" # Instance profile for nodes launched by Karpenter
    value = aws_iam_instance_profile.karpenter_node.name
  }
  set {
    name  = "settings.aws.interruptionQueueName" # Set to "" if not using SQS interruption handling, or your queue name
    value = "" # Example: "karpenter-${local.cluster_name}" if you create a queue.
  }
  # For EKS 1.29, ensure webhook.port is set if not default (9443) or if there are conflicts.
  # set {
  #   name = "webhook.port"
  #   value = "9443" # Default, usually fine
  # }

  depends_on = [
    aws_iam_role.karpenter_controller,
    aws_iam_role_policy.karpenter_controller,
    aws_iam_instance_profile.karpenter_node, # Ensure instance profile is created
    kubernetes_namespace.karpenter,
  ]
}

# NOTE on Karpenter Provisioning:
# After Karpenter is installed, you need to create NodePool and EC2NodeClass (for v0.32+)
# or Provisioner and AWSNodeTemplate (for older versions) custom resources.
# These define how Karpenter provisions nodes (e.g., instance types, subnets, security groups).
# Example (for Karpenter v0.32+):
#
# resource "kubernetes_manifest" "karpenter_default_nodepool" { ... }
# resource "kubernetes_manifest" "karpenter_default_ec2nodeclass" { ... }
#
# These are typically applied via kubectl apply -f <file.yaml> or managed through GitOps
# after the Karpenter controller is up and running and its CRDs are registered.
# Managing them directly with terraform-provider-kubernetes can sometimes be tricky due
# to CRD readiness timings.