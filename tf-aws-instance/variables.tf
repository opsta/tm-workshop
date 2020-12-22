# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_PROFILE

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region in which all resources will be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_name" {
  description = "AWS instance name"
  type        = string
  default     = "amazon_linux"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "amazon_linux"
}

variable "ssh_public_key" {
  description = "Public Key to create EC2 Key Pair that can be used to SSH to the EC2 Instances. Set to an empty string to not create Key Pair."
  type        = string
}

variable "aws_instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t2.micro"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami_id" {
  description = "The ID of the AMI to create instance. This is only use in case of you don't want our default Ubuntu AMI"
  type        = string
  default     = ""
}

variable "sg_egress_ports" {
  description = "A list of Egress Security Groups to attach to each EC2 Instance. Each item in the list should be an object with the keys 'protocol', 'from_port', 'to_port', 'cidr_blocks'."
  # We can't narrow the type down more than "any" because if we use list(object(...)), then all the fields in the
  # object will be required (whereas some, such as encrypted, should be optional), and if we use list(map(...)), all
  # the values in the map must be of the same type, whereas we need some to be strings, some to be bools, and some to
  # be ints. So, we have to fall back to just any ugly "any."
  type    = any
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "sg_ingress_ports" {
  description = "A list of Ingress Security Groups to attach to each EC2 Instance. Each item in the list should be an object with the keys 'protocol', 'from_port', 'to_port', 'cidr_blocks'."
  # We can't narrow the type down more than "any" because if we use list(object(...)), then all the fields in the
  # object will be required (whereas some, such as encrypted, should be optional), and if we use list(map(...)), all
  # the values in the map must be of the same type, whereas we need some to be strings, some to be bools, and some to
  # be ints. So, we have to fall back to just any ugly "any."
  type    = any
  default = [
    {
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp"
      from_port   = 8081
      to_port     = 8081
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
