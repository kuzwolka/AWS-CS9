# -------- HAproxy SG --------
resource "openstack_networking_secgroup_v2" "haproxy_sg" {
  name        = "haproxy_secg"
  description = "HAproxy security group"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_srule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.haproxy_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "http_srule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.haproxy_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "imcp_srule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.haproxy_sg.id
}