#----------------- MOST BASIC -----------
variable "cluster-name" {
  type = string
  default = "example"
}
variable "region" {
  type = string
  default = "ap-northeast-2"
}

#-----------------
variable "karpenter_chart_version" {
  description = "Version of Karpenter chart to install. Check https://github.com/aws/karpenter/releases"
  type        = string
  default     = "0.37.0" # For EKS 1.29, ensure compatibility. v0.32.0+ supports EKS 1.24-1.29.
}

variable "keda_chart_version" {
  description = "Version of KEDA chart to install. Check https://github.com/kedacore/charts/tree/main/keda"
  type        = string
  default     = "2.14.0" 
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD chart to install. Check https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd"
  type        = string
  default     = "6.7.7" 
}



# Locals block to derive values needed by configurations, especially Karpenter
locals {
  # Assumes aws_eks_cluster.example is defined in your main EKS cluster configuration
  cluster_name      = aws_eks_cluster.example.name
  oidc_issuer_url   = aws_eks_cluster.example.identity[0].oidc[0].issuer
  # Construct the OIDC provider ARN. EKS automatically creates an OIDC provider.
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(local.oidc_issuer_url, "https://", "")}"
  # Construct a standard IAM Service Account annotation
  irsa_annotation = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.cluster_name}-aws-load-balancer-controller-role"
  }
}