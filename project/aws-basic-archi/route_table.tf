resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "test-route-pub"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.test.id
  }

  tags = {
    Name = "test-route-pri"
  }
}

resource "aws_route_table_association" "routing-pub-a" {
  subnet_id = aws_subnet.pub-a.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "routing-pub-b" {
  subnet_id = aws_subnet.pub-b.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "routing-pri-a" {
  subnet_id = aws_subnet.pri-a.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "routing-pri-b" {
  subnet_id = aws_subnet.pri-b.id
  route_table_id = aws_route_table.private_route.id
}