# 서버의 포트 = SG에서의 서버 포트
variable "server_port" {
  description = "webserver port"
  type = number
  default = 8003
}