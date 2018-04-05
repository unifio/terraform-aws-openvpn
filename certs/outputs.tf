# Outputs

output "vpn_server_sg_id" {
  value = "${module.cluster.sg_id}"
}

output "vpn_whitelist" {
  value = "${var.vpn_whitelist}"
}

output "vpn_elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "vpn_elb_zone_id" {
  value = "${aws_elb.elb.zone_id}"
}

output "role_id_openvpn" {
  value = "${aws_iam_role.role.unique_id}"
}
