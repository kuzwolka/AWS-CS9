resource "openstack_compute_instance_v2" "cirros" {
  name              = "cirros-${count.index}"
  flavor_id         = "1"
  security_groups   = [ "default" ]
  count             = 2
}

0e05e5d9-2ea3-4ef5-935e-90fdc6acfb06