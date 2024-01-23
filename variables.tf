variable "rvpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
    type = bool
    default = true
}
variable "comman_tags" {
    type = map
    default ={}
}
variable "rvpc_tags" {
    type = map
    default = {}
}
variable "project_name" {
    default = {}
}
variable "environment" {
    default = {}
}
variable "gw_tags" {
    type = map
    default = {}
}
variable "public_subnets_cidr" {
   type = list
   validation {
         condition = length(var.public_subnets_cidr) == 2
         error_message = "pls provide two cidr numbers"
}
}
variable "public_subnets_tags" {
    default = {}
}
variable "private_subnets_cidr" {
   type = list
   validation {
         condition = length(var.private_subnets_cidr) == 2
         error_message = "pls provide two cidr numbers"
}
}
variable "private_subnets_tags" {
    default = {}
}

variable "database_subnets_cidr" {
   type = list
   validation {
         condition = length(var.database_subnets_cidr) == 2
         error_message = "pls provide two cidr numbers"
}
}
variable "database_subnets_tags" {
    default = {}
}
variable "nat_gateway_tags" {
    default = {}
}
variable "public_route_table_tags" {
    default = {}
}
variable "private_route_table_tags" {
    default = {}
}
variable "database_route_table_tags" {
    default = {}
}