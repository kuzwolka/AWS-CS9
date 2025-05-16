resource "aws_instance" "server" {
  ami = "ami-0f61efb6cfbcc18a4"
  instance_type = "t3.micro"
  count = 2
  
  tags = {
    Name = "server-${count.index}"
  }
}

output "server_name" {
    value= aws_instance.server.tags.Name
}