# Outputs

output "vpn_server_sg_id" {
  value = "${module.cluster.sg_id}"
}

output "vpn_whitelist" {
  value = "${var.vpn_whitelist}"
}
