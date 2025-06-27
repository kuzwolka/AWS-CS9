resource "openstack_networking_floatingip_v2" "haproxyfip" {
  pool = data.openstack_networking_network_v2.extnet.name
}

resource "openstack_compute_floatingip_associate_v2" "haproxyfip_asso" {
  floating_ip = openstack_networking_floatingip_v2.haproxyfip.address
  instance_id = openstack_compute_instance_v2.haproxy.id
}

output "haproxy_fip" {
  value = openstack_networking_floatingip_v2.haproxyfip.address
}

data "openstack_networking_network_v2" "extnet" {
  name = "extnet"
}