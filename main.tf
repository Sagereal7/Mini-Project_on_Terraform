provider "aws" {
  region = "eu-west-2"
  access_key = var.access_key
  secret_key = var.secret_access_key
}

# Create VPC
resource "aws_vpc" "mini_terra_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "mini_terra_vpc"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "mini_terra_internet_gateway" {
  vpc_id = aws_vpc.mini_terra_vpc.id
  tags = {
    Name = "mini_terra_internet_gateway"
  }
}

# Create public Route Table

resource "aws_route_table" "mini_terra_route_table_public" {
  vpc_id = aws_vpc.mini_terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mini_terra_internet_gateway.id
  }
  tags = {
    Name = "mini_terra_route_table_public"
  }
}

# Associate public subnet 1 with public route table

resource "aws_route_table_association" "mini_terra_public_subnet1_association" {
  subnet_id      = aws_subnet.mini_terra_public_subnet1.id
  route_table_id = aws_route_table.mini_terra_route_table_public.id
}

# Associate public subnet 2 with public route table
resource "aws_route_table_association" "mini_terra_public_subnet2_association" {
  subnet_id      = aws_subnet.mini_terra_public_subnet2.id
  route_table_id = aws_route_table.mini_terra_route_table_public.id
}

# Create Public Subnet-1

resource "aws_subnet" "mini_terra_public_subnet1" {
  vpc_id                  = aws_vpc.mini_terra_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "mini_terra_public_subnet1"
  }
}
# Create Public Subnet-2

resource "aws_subnet" "mini_terra_public_subnet2" {
  vpc_id                  = aws_vpc.mini_terra_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
  tags = {
    Name = "mini_terra_public_subnet2"
  }
}


resource "aws_network_acl" "mini_terra_network_acl" {
  vpc_id     = aws_vpc.mini_terra_vpc.id
  subnet_ids = [aws_subnet.mini_terra_public_subnet1.id, aws_subnet.mini_terra_public_subnet2.id]


  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}


