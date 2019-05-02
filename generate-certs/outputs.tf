# Outputs

output "role_id_certgen" {
  value = aws_iam_role.role.unique_id
}

