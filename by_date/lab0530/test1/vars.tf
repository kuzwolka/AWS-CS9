# -------- openstack authentication info --------
variable "tenant_name" {
  type = string
  default = "admin"
}
variable "user_name" {
  type = string
  default = "admin"
}
variable "password" {
  type = string
  default = "test123"
}
variable "auth_url" {
  type = string
  default = "http://211.183.3.10:5000/v3"
}
variable "region" {
  type = string
  default = "RegionOne"
}

# -------- network --------
variable "external_network_id" {
  description = "external network's id"
  type = string
  default = "6e3c144f-32c5-4e0f-bfd7-936a071f8d1e"
}

variable "flavor" {
  description = "instance's flavor"
  type = string
  default = "t2.small"
}

variable "image" {
  description = "instance's image"
  type = string
  default = "Ubuntu2204"
}