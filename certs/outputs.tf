# Outputs

output "vpn_server_sg_id" {
  value = "${module.cluster.sg_id}"
}

output "cidr_whitelist" {
  value = "${var.cidr_whitelist}"
}
