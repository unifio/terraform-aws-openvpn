data "aws_ami" "cluster_ami" {
  owners = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

