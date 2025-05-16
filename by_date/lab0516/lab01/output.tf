# 인스턴스의 이름이 example-asg-instance인 것만 모음 -> pub ip/pub dns 출력
# data/filter로 인스턴스 필터링
data "aws_instances" "asg_instances" {
  filter {
    name = "tag:Name"
    values = ["example-asg-instance"]
  }
}

# after filtering ... for print
output "asg_instances_public_ips" {
  description = "ASG-created instances's pub ips"
  value = data.aws_instances.asg_instances.public_ips
}