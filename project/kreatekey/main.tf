terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "key_name" {
  type = string
  default = "mykey.pem"
}

# Generate RSA private key
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write private key to file in current directory
resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/${var.key_name}"
  file_permission = "0600"
}

# Write public key to file in current directory
resource "local_file" "public_key" {
  content  = tls_private_key.example.public_key_openssh
  filename = "${path.module}/${var.key_name}.pub"
}
