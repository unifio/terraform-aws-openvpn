# Outputs
output "vpn_server_sg_id" {
  value = module.cluster.sg_id
}

output "role_id_openvpn" {
  value = aws_iam_role.role.unique_id
}

output "vpn_server_eip_id" {
  value = element(concat(aws_eip.openvpn_eip.*.id, [""]), 0)
}

