data "aws_availability_zones" "available_azs_region1" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "prod-vpc-1"
  cidr = "10.200.0.0/16"

  azs             = [element(data.aws_availability_zones.available_azs_region1.names, 0)]
  private_subnets = ["10.200.101.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

// Instances
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc1_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.allow_ssh.id]
  tags = {
    Name = "private ec2 instance 1"
  }
}