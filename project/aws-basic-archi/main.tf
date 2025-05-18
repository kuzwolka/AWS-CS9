resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "pub-a" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "pub-b" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "pri-a" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "pri-b" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = false
  
  tags = {
    Name = "private-subnet-b"
  }
}