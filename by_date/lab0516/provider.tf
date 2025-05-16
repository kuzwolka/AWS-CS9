# Define required providers
terraform {
required_version = ">= 1.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.54.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}