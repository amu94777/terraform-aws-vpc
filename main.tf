resource "aws_vpc" "rvpc" {
  cidr_block = var.rvpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.comman_tags,var.rvpc_tags)
}