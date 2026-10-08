
provider "aws" {
    region = "eu-north-1"
}

variable "cidr_block" {
  description = "CIDR blocks and name tags for vpc and subnet"
  type        = list(object({
    cidr = string
    name = string
  }))
}



variable "environment" {
  description = "Development environment"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

resource "aws_vpc" "development_vpc" {
  cidr_block = var.cidr_block[0].cidr
  tags = {
    Name = var.cidr_block[0].name
  }
}

resource "aws_subnet" "development_subnet-1" {
  vpc_id            = aws_vpc.development_vpc.id
  cidr_block        = var.cidr_block[1].cidr
  availability_zone = var.availability_zone
  tags = {
    Name = var.cidr_block[1].name
  }
}

output "dev-vpc-id" {
  value = aws_vpc.development_vpc.id
}

output "dev-subnet-1-id" {
  value = aws_subnet.development_subnet-1.id
}