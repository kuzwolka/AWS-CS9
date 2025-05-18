locals {
  vpc_name = "test-vpc"
  cidr = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.100.0/24", "10.0.101.0/24"]
  avail_zones = ["${var.region}a", "${var.region}b"]
}

resource "aws_vpc" "test" {
    cidr_block = local.cidr
    tags = { Name = local.vpc_name }
}

resource "aws_default_route_table" "test" {
  default_route_table_id = aws_vpc.test.default_route_table_id
  tags = { Name = "${local.vpc_name}-default-route" }
}

resource "aws_default_security_group" "test" {
  vpc_id = aws_vpc.test.id
  tags = { Name = "${local.vpc_name}-default-sg" }
}

resource "aws_internet_gateway" "test" {
    vpc_id = aws_vpc.test.id
    tags = { Name = "${local.vpc_name}-igw" }
}

resource "aws_subnet" "public_subnets" {
  count = length(local.public_subnets)

  vpc_id = aws_vpc.test.id
  cidr_block = local.public_subnets[count.index]
  availability_zone = local.avail_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(local.private_subnets)

  vpc_id = aws_vpc.test.id
  cidr_block = local.private_subnets[count.index]
  availability_zone = local.avail_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.vpc_name}-private-subnet-${count.index + 1}"
  }
}