# key-pair Openstack registration
resource "openstack_compute_keypair_v2" "keypair2" {
  name = "testkey2"
  public_key = file("/root/AWS-CS9/by_date/lab0515/terraform01/hello.pem.pub")

}

# start instance
resource "openstack_compute_instance_v2" "basic" {
  name              = "ubuntu"
  image_id          = "272911c7-88f2-42cb-b4d2-c1eeae3b7d4a"
  flavor_id         = "2"
  security_groups   = ["basicSG"]
  key_pair          = openstack_compute_keypair_v2.keypair2.name

  network {
    name = "mynet"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
            #!/bin/bash
            touch test.txt
            sudo apt update
            sudo apt install -y nginx ssh
            EOF
}

# 인스턴스 사설 주소 = 매핑 =  공인주소(floating IP)
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "extnet"
}

# 위에서 발행한 공인주소를 특정 인스턴스(cirros1)와 매핑핑
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  # 공인 주소
  instance_id = openstack_compute_instance_v2.basic.id
  # 어떤 인스턴스의
  fixed_ip    = openstack_compute_instance_v2.basic.network.0.fixed_ip_v4
  # 어떤 사설주소(랜카드)와 매핑할 것인지
}

# 매핑 결과 확인 
# 다 되고 공인IP 주소 output되게
output "public-IP" {
  value = openstack_networking_floatingip_v2.fip_1.address
}


resource "terraform_data" "apply2" {
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/root/AWS-CS9/by_date/lab0515/terraform01/hello.pem")
    host = openstack_networking_floatingip_v2.fip_1.address
  }


  provisioner "remote-exec" {
    # 로컬에만 만들어 두면 자동으로 원격지에 복사>실행행
    script = "/root/AWS-CS9/by_date/lab0515/terraform01/test.sh"
  }
}
