variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "az" {
  type = list(string)
  default = [ "a", "b", "c" ]
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.100.0/24", "10.0.101.0/24"]
}