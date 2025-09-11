variable "inst_count" {
  description = "no of ec2 instances to create"
  type        = number
  default     = 2
}

variable "ec2_name" {
  description = "name for ec2 instances"
  type        = list(string)
  default     = ["from_tf_created"]
}