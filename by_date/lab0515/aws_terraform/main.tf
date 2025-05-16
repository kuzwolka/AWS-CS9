resource "aws_key_pair" "deployer" {
  key_name   = "hello-key"
  public_key = file("//root/AWS-CS9/by_date/lab0515/aws_terraform/hello.pem.pub")
}

# 기본 옵션으로 인스턴스 생성
resource "aws_instance" "test1" {
  ami     = "ami-05a7f3469a7653972" 
  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type x86 선택
  instance_type = "t2.small"
  security_groups = [ aws_security_group.webssh.name ]
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = "test1"
  }
  user_data = <<-EOT
              #!/bin/bash
              touch test.txt
              apt update
              apt install -y nginx
              EOT
  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "hello, all" > index.html
  #             nohup busybox httpd -f -p ${var.server_port} &
  #             EOF
}

output "privateIP" {
  value = aws_instance.test1.private_ip
}

output "publicDNS" {
  value = aws_instance.test1.public_dns
}

output "publicIP" {
  value = aws_instance.test1.public_ip
}