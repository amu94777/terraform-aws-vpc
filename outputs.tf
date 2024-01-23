output "azs" {
    value = data.aws_availability_zones.azs.names
}
output "rvpc_id" {
    value = aws_vpc.rvpc.id
}
output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}
output "database_subnet_ids" {
    value = aws_subnet.database[*].id
}
