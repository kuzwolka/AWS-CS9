resource "aws_autoscaling_group" "example" {
  name = "example-asg"
  max_size = "4"
  min_size = "2"
  desired_capacity = "2"
  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "example-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    replace_triggered_by = [ aws_launch_template.example.user_data ]
  }
}

# default vpc selection
data "aws_vpc" "default" {
    default = true
}

# subnets in default vpc
data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
}