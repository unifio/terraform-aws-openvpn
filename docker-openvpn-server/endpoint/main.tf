resource "aws_lb" "openvpn" {
  name = "${var.stack_item_label}-nlb"

  internal           = false
  load_balancer_type = "network"

  #TODO:
  security_groups = []
  subnets         = split(",", coalesce(var.lb_subnets, var.subnets))

  access_logs {
    bucket  = var.lb_logs_bucket
    prefix  = var.lb_logs_bucket_prefix
    enabled = var.lb_logs_enabled
  }

  tags = {
    Name        = var.stack_item_label
    application = var.stack_item_fullname
    managed_by  = "terraform"
  }
}

resource "aws_lb_target_group" "openvpn" {
  name     = "${var.stack_item_label}-nlb"
  port     = 1194
  protocol = "TCP"

  vpc_id = var.vpc_id

  #deregistration_delay
  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 4

    # default is 10, that cannot be changed for an NLB
    #timeout            = 10
    port = 1194

    protocol = "TCP"
    interval = 30
  }

  tags = {
    Name        = var.stack_item_label
    application = var.stack_item_fullname
    managed_by  = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "openvpn" {
  load_balancer_arn = aws_lb.openvpn.arn
  port              = 1194
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.openvpn.id
    type             = "forward"
  }
}

