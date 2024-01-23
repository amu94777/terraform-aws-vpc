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
resource "aws_internet_gateway" "igw" {
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
resource "aws_subnet" "database" {
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
resource "aws_db_subnet_group" "dbsubg" {
  name       = "${local.name}"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${local.name}"
  }
}

### eip conf ####
resource "aws_eip" "eip" {
  domain = "vpc"
} 

####natgateway conf ####
resource "aws_nat_gateway" "rnatgate" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.comman_tags,var.nat_gateway_tags,
         
  {
    Name = "${local.name}"
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
###### public route table conf ######
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.rvpc.id
  tags = merge(var.comman_tags,var.public_route_table_tags,
         {
           Name = "${local.name}-public"
  }
  )
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.rvpc.id
  tags = merge(var.comman_tags,var.private_route_table_tags,
         {
           Name = "${local.name}-private"
  }
  )
}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.rvpc.id
  tags = merge(var.comman_tags,var.database_route_table_tags,
         {
           Name = "${local.name}-database"
  }
  )
}
##### adding routes ####

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.rnatgate.id
}
resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.rnatgate.id
}
####### route table assosiation with subnets ####
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count = length(var.database_subnets_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}


