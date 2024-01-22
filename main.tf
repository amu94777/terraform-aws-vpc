resource "aws_vpc" "rvpc" {
  cidr_block = var.rvpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.comman_tags,var.rvpc_tags,
          {
            Name = local.name
          }
  )
}
###### internet gate way ####
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.rvpc.id
 tags = merge(var.comman_tags,var.gw_tags,
 {
    Name = local.name
  }
 )
}