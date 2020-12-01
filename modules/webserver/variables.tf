variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "cidr_block" {
  type        = string
  description = "subnet cidr block"
}

variable "webserver_name" {
  type        = string
  description = "Name of the webserver"
}

variable "ami" {
  type        = string
  description = "AMI of the EC2 instance to be launched in the region"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to be launched"
  default     = "t2.micro"
}
