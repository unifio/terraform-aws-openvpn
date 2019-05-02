# inputs
locals {
  in_sg_id            = module.cluster.sg_id
  in_sg_vpn_whitelist = var.vpn_whitelist
  in_sg_ssh_whitelist = var.ssh_whitelist
}

## Creates security group rules
resource "aws_security_group_rule" "cluster_allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.in_sg_id
}

resource "aws_security_group_rule" "cluster_allow_openvpn_tcp_in" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = split(",", local.in_sg_vpn_whitelist)
  security_group_id = local.in_sg_id
}

resource "aws_security_group_rule" "cluster_allow_ssh_in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = split(",", local.in_sg_ssh_whitelist)
  security_group_id = local.in_sg_id
}

resource "aws_security_group_rule" "cluster_allow_icmp_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = split(",", var.ssh_whitelist)
  security_group_id = local.in_sg_id
}

