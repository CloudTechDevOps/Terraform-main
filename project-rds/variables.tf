############### Main Variables ##################

variable "main_allocated_storage"{
type = number
description = "strorge"
}
variable "main_db_engine"{
type = number
}
variable "main_db_instance_class"{
type = number
}
variable "main_db_username" {
type = string  
}
variable "parameter_group_name" {
    type = string 
}
variable "password " {
type = string  
}
variable "main_db_version" {
    type = string
  
}
#################replica##############
variable "replica_instance_class" {
    type = string
  
}

variable "replica_count" {
  type = number
  default = 2
}

variable "rds_replica_azs" {
  type = list(string)
  default = []
}
variable "sg_vpc_id" {
    type = string
  
}
variable "sg_ingress_from_port" {
    type = number
  
}
variable "sg_ingress_to_port" {
    type = number
  
}
variable "cidr"{
type = list(string)
}
variable "sg_protocol" {
    type = string
}
variable "sg_name" {
  type = string
}
