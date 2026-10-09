
/*
# Creating a new Security Group
resource "aws_security_group" "myapp_sg" {
  name        = "${var.env_prefix}-myapp-sg"
  description = "Security group for myapp"
  vpc_id      = aws_vpc.myapp_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-myapp-sg"
  }
}*/

# using default security group created while creating the vpc
# The difference between creating a new sg and using the existing default one is the resource name
resource "aws_default_security_group" "default_sg" {
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = [var.image-name]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_key_pair" "ssh_key_pair" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

# Creating EC2 Server Instance
resource "aws_instance" "myapp_server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_default_security_group.default_sg.id]
  availability_zone = var.availability_zone

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key_pair.key_name

  user_data = file(var.user_data_script_location)

  # make sure server is clean when we destroy and create new server
  user_data_replace_on_change = true

  tags = {
    Name = "${var.env_prefix}-server"
  }
}
