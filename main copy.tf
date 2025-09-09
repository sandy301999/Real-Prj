provider "aws" {
  region = "us-east-1"
}

# Get default VPC and subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group (allow SSH + HTTP)
resource "aws_security_group" "sg" {
  name        = "ansible-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ubuntu servers
resource "aws_instance" "Linux" {
  count         = 3
  ami           = "ami-00ca32bbc84273381" #Amazon Linux
  instance_type = "t2.micro"
  subnet_id     = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name      = "kops-key"

  tags = {
    Name = "ubuntu-${count.index}"
  }
}

# OEL servers
resource "aws_instance" "Ubuntu" {
  count         = 3
  ami           = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  subnet_id     = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name      = "kops-key"

  tags = {
    Name = "oel-${count.index}"
  }
}

# Save IPs for Ansible inventory
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content = <<EOT
[ubuntu]
%{ for ip in aws_instance.Ubuntu.*.public_ip ~}
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/kops-key.pem
%{ endfor ~}

[amazon_linux]
%{ for ip in aws_instance.Linux.*.public_ip ~}
${ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/kops-key.pem
%{ endfor ~}
EOT
}
