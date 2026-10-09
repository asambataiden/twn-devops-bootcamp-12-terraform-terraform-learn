# Creating subnet for our vpc
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "${ var.env_prefix }-subnet-1"
  }
}


# creating Internet Gate-Way
resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${ var.env_prefix }-internet-gateway"
  }
}

# using default rout table created while creating the vpc
resource "aws_default_route_table" "main-route-table" {
  default_route_table_id = var.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_igw.id
  }
  tags = {
    Name = "${ var.env_prefix }-main-route-table"
  }
}

# associate our subnet to our route table
resource "aws_route_table_association" "myapp_route_table_association" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_default_route_table.main-route-table.id
}