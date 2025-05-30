# -------- Create Router --------
resource "openstack_networking_router_v2" "router1" {
  name                = "router1"
  external_network_id = var.external_network_id
}

# -------- Connect Router's interface to HAproxy's subnet --------
resource "openstack_networking_router_interface_v2" "haproxy_interface" {
  router_id = openstack_networking_router_v2.router1.id
  subnet_id = openstack_networking_subnet_v2.haproxy_subnet.id
}

# -------- Connect Router's interface to web server's subnet --------
resource "openstack_networking_router_interface_v2" "web_interface" {
  router_id = openstack_networking_router_v2.router1.id
  subnet_id = openstack_networking_subnet_v2.web_subnet.id
}