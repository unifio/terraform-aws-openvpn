# Outputs
output "vpn_server_sg_id" {
  value = module.cluster.vpn_server_sg_id
}

output "vpn_whitelist" {
  value = var.vpn_whitelist
}

output "vpn_lb_dns_name" {
  value = module.endpoint.lb_dns_name
}

output "vpn_lb_zone_id" {
  value = module.endpoint.lb_dns_zone_id
}

output "role_id_openvpn" {
  value = module.cluster.role_id_openvpn
}

