# openvpn_server - Output Variables

/* ---------------------------- */
## VPN server security group ID */
/* ---------------------------- */
output "vpn_server_sg_id" {
  value = "${module.asg.sg_id}"
}

output "cidr_whitelist" {
  value = "${var.cidr_whitelist}"
}
