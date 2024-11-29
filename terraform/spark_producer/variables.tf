variable "vpc_id" {
  description = "The ID of the VPC to use for Kafka resources"
  type        = string
}

variable "instance_count" {
  description = "Number of instance to create"
  type        = string
}

variable "aws_ami_debian_id" {
  description = "Subnet's id"
  type        = string
}

variable "route_table_id" {
  description = "AWS route table id"
  type        = string
}

variable "aws_key_pair_name" {
  description = "AWS route table id"
  type        = string
}
