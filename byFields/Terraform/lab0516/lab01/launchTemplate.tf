resource "aws_key_pair" "testkey" {
  key_name   = "hello-key"
  public_key = file("//root/AWS-CS9/by_date/lab0516/keys/hello.pem.pub")
}

resource "aws_launch_template" "example" {
  name = "example"

  # instance
  image_id = "ami-0f61efb6cfbcc18a4" # amazon linux 2(x86)
  instance_type = "t3.micro"
  key_name = aws_key_pair.testkey.key_name
  vpc_security_group_ids = [ aws_security_group.instance-sg.id ]

  user_data = base64encode(<<-EOF
          #!/bin/bash
          yum -y install httpd
          sed -i "s/^Listen 80$/Listen ${var.server_port}/" /etc/httpd/conf/httpd.conf
          echo "hello" > /var/www/html/index.html
          systemctl restart httpd
          EOF
          )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "example"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
