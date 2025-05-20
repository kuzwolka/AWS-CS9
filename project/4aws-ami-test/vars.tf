variable "region" {
  type = string
  default = "ap-northeast-2"
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
variable "vpc_name" {
  type = string
  default = "test-vpc"
}

variable "server_port" {
  description = "webserver port"
  type = number
  default = 80
}

variable "availability_zones" {
  type = map(string)
  default = {
    "ap-northeast-2" = "ap-northeast-2a,ap-northeast-2b,ap-northeast-2c,ap-northeast-2d"
    "ap-northeast-1" = "ap-northeast-1a,ap-northeast-1c,ap-northeast-1d"
    "us-west-2" = "us-west-2a,us-west-2b,us-west-2c"
    "us-east-1" = "us-east-1c,us-west-1d,us-west-1e"
  }
}