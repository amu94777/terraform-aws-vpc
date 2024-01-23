resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id        = aws_vpc.vpc.id
  peer_vpc_id = var.accepter_vpc_id == "" ? data.aws_vpc.default.id : var.accepter_vpc_id
  auto_accept = var.accepter_vpc_id == "" ? true : false
  tags = merge(var.comman_tags,var.vpc_peering_tags,
            {
                Name = "${local.name}"
            }
  )
}
##### default vpc  routes for peering ###
resource "aws_route" "accepter_route" {
    count = var.is_peering_required && var.accepter_vpc_id == "" ? 1 : 0
    route_table_id            = data.aws_route_table.default.id ####default vpc rt
    destination_cidr_block    = var.vpc_cidr  ####roboshop vpc
    vpc_peering_connection_id =  aws_vpc_peering_connection.peering[0].id  
}
#####public,private ,database route tables routes for peering ###
resource "aws_route" "public_peering" {
    count = var.is_peering_required && var.accepter_vpc_id == "" ? 1 : 0
    route_table_id            = aws_route_table.public.id ####publis rt for roboshop vpc
    destination_cidr_block    = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id =  aws_vpc_peering_connection.peering[0].id  
}
resource "aws_route" "private_peering" {
    count = var.is_peering_required && var.accepter_vpc_id == "" ? 1 : 0
    route_table_id            = aws_route_table.private.id
    destination_cidr_block    = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id =  aws_vpc_peering_connection.peering[0].id  
}
resource "aws_route" "database_peering" {
    count = var.is_peering_required && var.accepter_vpc_id == "" ? 1 : 0
    route_table_id            = aws_route_table.database.id
    destination_cidr_block    = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id =  aws_vpc_peering_connection.peering[0].id  
}

