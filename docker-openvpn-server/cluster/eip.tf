resource "aws_eip" "openvpn_eip" {
  count = var.assign_eip == "true" ? 1 : 0
  vpc   = true

  tags = {
    application = var.stack_item_fullname
    managed_by  = "terraform"
    Name        = var.stack_item_label
  }
}

