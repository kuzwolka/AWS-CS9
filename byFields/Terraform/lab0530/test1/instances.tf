resource "openstack_images_image_v2" "ubuntu" {
  name = var.image
  local_file_path = "./jammy-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format = "qcow2"
}

resource "openstack_compute_flavor_v2" "t2small" {
  name = var.flavor
  ram   = "2048"
  vcpus = "2"
  disk  = "20"

  is_public = true
}

resource "openstack_compute_instance_v2" "haproxy" {
  name              = "haproxy"
  flavor_name       = openstack_compute_flavor_v2.t2small.name
  image_name        = openstack_images_image_v2.ubuntu.name
  key_pair          = openstack_compute_keypair_v2.testkey.name
  security_groups   = [openstack_networking_secgroup_v2.haproxy_sg.name] 

  depends_on = [ openstack_compute_instance_v2.web ]

  network {
    uuid = openstack_networking_network_v2.prinet.id
    fixed_ip_v4 = "172.16.101.10"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_compute_instance_v2" "web" {
  count         = 2
  name          = "web-${count.index}"
  image_name    = openstack_images_image_v2.ubuntu.name
  flavor_name   = openstack_compute_flavor_v2.t2small.name
  key_pair          = openstack_compute_keypair_v2.testkey.name
  security_groups   = [openstack_networking_secgroup_v2.haproxy_sg.name] 

  network {
    uuid = openstack_networking_network_v2.prinet.id
    fixed_ip_v4 = "172.16.102.${count.index + 10}"
  }

  user_data = file("${path.module}/user_data/user_service.yml")

}