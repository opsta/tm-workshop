# ---------------------------------------------------------------------------------------------------------------------
# CREATE INSTANCE(S) ON AWS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE EC2 INSTANCE(S)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "instance" {
  count                  = 1
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.aws_instance_type
  key_name               = var.ssh_key_name
  tags                   = { Name = var.instance_name }
  vpc_security_group_ids = [aws_security_group.security_group.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE EC2 KEY PAIR
# ---------------------------------------------------------------------------------------------------------------------

module "key_pair" {
  source          = "terraform-aws-modules/key-pair/aws"
  key_name        = var.ssh_key_name
  public_key      = var.ssh_public_key
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF EACH EC2 INSTANCE
# We export the ID of the security group as an output variable so users can attach custom rules.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "security_group" {
  name        = var.instance_name
  description = "Security group for the ${var.instance_name} instance"

  dynamic "egress" {
    for_each          = var.sg_egress_ports
    content {
      protocol        = egress.value["protocol"]
      from_port       = egress.value["from_port"]
      to_port         = egress.value["to_port"]
      cidr_blocks     = lookup(egress.value, "cidr_blocks", null)
      security_groups = lookup(egress.value, "security_groups", null)
    }
  }

  dynamic "ingress" {
    for_each          = var.sg_ingress_ports
    content {
      protocol        = ingress.value["protocol"]
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GET LATEST AMI ID FOR EACH OS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
