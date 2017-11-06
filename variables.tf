
// Standard Variables

variable "name" {
  description = "Name"
}
variable "environment" {
  description = "Environment (ex: dev, qa, stage, prod)"
}
variable "namespaced" {
  description = "Namespace all resources (prefixed with the environment)?"
  default     = true
}
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

// Module specific Variables

variable "cidr" {
  description = "The cidr block to use for internal security groups"
}
variable "security_groups" {
  description = "Comma separated list of security groups"
}
variable "vpc_id" {
  description = "The VPC ID"
}
