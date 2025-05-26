# Define required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1" # Please check for the latest stable version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.2" # Please check for the latest stable version
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {} # Gets region from the AWS provider configuration

provider "kubernetes" {
  host                   = aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # Ensure your AWS CLI is configured and has permissions to get a token for the cluster.
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.example.name, "--region", data.aws_region.current.name]
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.example.name, "--region", data.aws_region.current.name]
    }
  }
}