resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.vpc_cidr}"
  region = "eu-west-2"
  tags = {
    name = "${var.costcenter}-${var.env}-vpc"
    environment = var.env
    costcenter = var.costcenter
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { 
  Name = "igw-${var.env}" 
  }
}


# public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(var.azs, count.index)
  tags = {
  Name = "${var.project}-${var.environment}-public-${count.index}"
  Tier = "public"
  Environment = var.environment
  Project = var.project
  Owner = var.owner
  }
}


# private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)
  tags = {
  Name = "${var.project}-${var.environment}-private-${count.index}"
  Tier = "private"
  Environment = var.environment
  Project = var.project
  Owner = var.owner
  }
}


# NAT Gateway in first public subnet (example)
resource "aws_eip" "nat" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  tags = { 
    Name = "nat-${var.environment}" 
    }
}


# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
tags = {
  Name = "public-rt-${var.environment}" 
  }
}


resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { 
  Name = "private-rt-${var.environment}" 
  }
}


resource "aws_route_table_association" "private_assoc" {
 count = length(aws_subnet.private)
 subnet_id = aws_subnet.private[count.index].id
 route_table_id = aws_route_table.private.id
}
