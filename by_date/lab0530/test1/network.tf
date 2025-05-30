locals {
  lb_subnet_cidr = "172.16.101.0/24"
  lb_subnet_gw = "172.16.101.1"
  web_subnet_cidr = "172.16.102.0/24"
  web_subnet_gw = "172.16.102.1"
  dns_nameservers = ["8.8.8.8","168.126.63.1"]
}

# -------- Network --------
resource "openstack_networking_network_v2" "prinet" {
  name           = "prinet"
}

# -------- LB subnet --------
resource "openstack_networking_subnet_v2" "haproxy_subnet" {
  description = "Haproxy LB subnet"
  name = "haproxy_subnet"
  network_id = openstack_networking_network_v2.prinet.id
  cidr       = local.lb_subnet_cidr
  gateway_ip = local.lb_subnet_gw
  dns_nameservers = local.dns_nameservers
}

# -------- Web subnet --------
resource "openstack_networking_subnet_v2" "web_subnet" {
  description = "Webserver subnet"
  name = "web_subnet"
  network_id = openstack_networking_network_v2.prinet.id
  cidr       = local.web_subnet_cidr
  gateway_ip = local.web_subnet_gw
  dns_nameservers = local.dns_nameservers
}