resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "${local.cluster_name}-aws-load-balancer-controller-policy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = file("iam_policy.json")
}
  
# Helm Release for AWS Load Balancer Controller
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.2" # Use a specific, compatible version. Check for the latest version.
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = local.cluster_name
  }
  # Configure IRSA here - see next step for aws_iam_role creation.
}