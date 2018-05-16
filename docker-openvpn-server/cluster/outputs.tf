# Outputs
output "vpn_server_sg_id" {
  value = "${module.cluster.sg_id}"
}

output "role_id_openvpn" {
  value = "${aws_iam_role.role.unique_id}"
}
