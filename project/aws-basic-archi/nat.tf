resource "aws_nat_gateway" "test" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.pub-a.id

  tags = {
    Name = "test-NAT-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "test-igw"
  }
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
}