variable "env_name" { default = "dev" }
variable "region"   { default = "us-east-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "ports" { default = [22, 80, 443] }