# Declare the data source
data "aws_availability_zones" "azs" {
  state = "available"
}
#### default vpc information ###
data "aws_vpc" "default" {
  default = true
} 
####default vpc route table ###
data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id
}