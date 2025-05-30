locals {
  key_name = "test1key"
}

# Generate RSA private key
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write private key to file in current directory
resource "local_file" "private_key_file" {
  content         = tls_private_key.private_key.private_key_pem
  filename        = "${path.module}/${local.key_name}.pem"
  file_permission = "0600"
}

resource "openstack_compute_keypair_v2" "testkey" {
  name = local.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}