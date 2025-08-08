resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_vpc"
    }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_public_subnet"
  }
    
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_private_subnet"
  }
}

resource "aws_security_group" "sg_public" {
  name        = "${var.wanderlust_project_name}_${var.environment}_security_group_public"
  description = "Security group for ${var.wanderlust_project_name} ${var.environment} application"
  vpc_id      = aws_vpc.main.id

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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_private" {
  name        = "${var.wanderlust_project_name}_${var.environment}_security_group_private"
  description = "Security group for private resources"
  vpc_id      = aws_vpc.main.id

  ingress {
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
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_internet_gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_nat_gateway"
  }
  
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_private_route_table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.wanderlust_project_name}_${var.environment}_key"
  public_key = file(var.public_key_path)
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_key_pair"
  }
}

# Data source for latest Ubuntu 22.04 LTS AMI
# Canonical's owner ID: 099720109477
# Name pattern for Ubuntu 22.04 LTS: ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "app-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  
  tags = {
    Name = "${var.wanderlust_project_name}_${var.environment}_app_server_ubuntu"
  }
  
}