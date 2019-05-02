output "lb_dns_name" {
  value = aws_lb.openvpn.dns_name
}

output "lb_dns_zone_id" {
  value = aws_lb.openvpn.zone_id
}

output "lb_target_group_arns" {
  value = aws_lb_target_group.openvpn.arn
}

