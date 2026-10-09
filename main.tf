
provider "aws" {
  region = "eu-north-1"
}

# Creating our vpc
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${ var.env_prefix }-vpc"
  }
}


module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp_vpc.id
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}

module "myapp-webserver" {
  source = "./modules/webserver"
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp_vpc.id
  subnet_id = module.myapp-subnet.subnet.id
  availability_zone = var.availability_zone
  image-name = var.image-name
  instance_type = var.instance_type
  my_ip = var.my_ip
  public_key_location = var.public_key_location
  user_data_script_location = var.user_data_script_location

}
