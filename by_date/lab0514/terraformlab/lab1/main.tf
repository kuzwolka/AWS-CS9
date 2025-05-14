resource "openstack_compute_instance_v2" "basic" {
  name              = "cirros1"
  image_id          = "0e05e5d9-2ea3-4ef5-935e-90fdc6acfb06"
  flavor_id         = "1"
  security_groups   = ["default"]

  network {
    name = "mynet"
  }
}