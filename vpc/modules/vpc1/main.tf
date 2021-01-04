data "aws_availability_zones" "available_azs_region1" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "prod-nat-eip"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "prod-vpc"
  cidr   = "10.100.0.0/16"

  azs                    = [element(data.aws_availability_zones.available_azs_region1.names, 0)]
  public_subnets         = ["10.100.1.0/24"]
  private_subnets        = ["10.100.101.0/24"]
  create_egress_only_igw = true
  enable_dns_hostnames   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  reuse_nat_ips          = true # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids    = [aws_eip.nat.id]

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
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "ec2-a" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.allow_ssh.id]
  tags = {
    Name = "public ec2 instance"
  }
}

resource "aws_instance" "ec2-b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = element(module.vpc.private_subnets, 0)
  tags = {
    Name = "private ec2 instance"
  }
}
