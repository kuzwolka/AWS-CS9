variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "access_key" {
  description = "aws access key"
  type = string
  default = "-"
}
variable "secret_key" {
  description = "aws secret key"
  type = string
  default = "-"
}
variable "session_token" {
  description = "aws session token"
  type = string
  default = "-"
}