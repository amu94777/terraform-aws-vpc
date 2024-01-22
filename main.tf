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
####### public subnet conf ####
resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.rvpc.id
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.comman_tags,var.public_subnets_tags,
           {
             Name = "${local.name}-public-${local.az_names[count.index]}"
            }
  )
}
####### private subnet conf ####
resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.rvpc.id
  cidr_block = var.private_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.comman_tags,var.private_subnets_tags,
           {
             Name = "${local.name}-private-${local.az_names[count.index]}"
            }
  )
}
####### database subnet conf ####
resource "aws_subnet" "databse" {
  count = length(var.database_subnets_cidr)
  vpc_id     = aws_vpc.rvpc.id
  cidr_block = var.database_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.comman_tags,var.database_subnets_tags,
           {
             Name = "${local.name}-database-${local.az_names[count.index]}"
            }
  )
}

