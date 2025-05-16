resource "openstack_compute_instance_v2" "cirros" {
  name              = "cirros-${count.index}"
  flavor_id         = "1"
  security_groups   = [ "default" ]
  count             = 2

  block_device {
    uuid                    = "0e05e5d9-2ea3-4ef5-935e-90fdc6acfb06"
    source_type             = "image"
    destination_type        = "volume"
    volume_size             = 3
    boot_index              = 0
    delete_on_termination   = true
    
  }

  network {
    name = "mynet"
  }
}

output "instance-private-ip" {
  value = openstack_compute_instance_v2.cirros.*.network.0.fixed_ip_v4
}