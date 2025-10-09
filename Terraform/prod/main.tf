provider "aws" {
  region = var.region
  default_tags {
    tags = { Environment = var.env_name }
  }
}

module "vpc" {
  source      = "../modules/vpc"
  cidr_block  = var.vpc_cidr
  subnet_cidr = "10.1.1.0/24"
  name        = "${var.env_name}-vpc"
  az          = "us-east-1a"
}

module "sg" {
  source  = "../modules/sg"
  vpc_id  = module.vpc.vpc_id
  ports   = var.ports
  env_name = var.env_name
}

module "ec2" {
  source       = "../modules/ec2"
  instance_count = 3
  instance_type  = "t3.small"
  subnet_id      = module.vpc.subnet_id
  sg_id          = module.sg.sg_id
  env_name       = var.env_name
}

resource "null_resource" "post_apply" {
  provisioner "local-exec" {
    command = "echo 'Apply completed for ${var.env_name}'"
  }
  triggers = { env = var.env_name }
}