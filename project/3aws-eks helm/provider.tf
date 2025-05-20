# Define required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}