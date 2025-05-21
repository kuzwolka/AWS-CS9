resource "aws_s3_bucket" "example" {
  count = var.s3
  bucket = "s3-${var.id}-${var.s3}"

  tags = {
    Name = "s3-${var.id}-${var.s3}"
  }
}