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
    default = {
        project = "roboshop"
        env = "dev"
        Terraform = true
    }
}
variable "rvpc_tags" {
    type = map
    default = {}
}