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