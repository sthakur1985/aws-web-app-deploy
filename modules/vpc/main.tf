# Validate subnet counts
resource "null_resource" "subnet_validation" {
  count = length(var.public_subnet_cidrs) > local.max_subnets || length(var.ec2_private_subnet_cidrs) > local.max_subnets || length(var.rds_private_subnet_cidrs) > local.max_subnets ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Error: Number of subnets exceeds available AZs' && exit 1"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # DNS Configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name = "${var.project}-${var.env}-vpc"
  }, local.common_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.env}-igw"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}


# Public subnets
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.env}-public-${count.index + 1}"
    Tier        = "Public"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}


# EC2 Private subnets (2 subnets in 2 AZs)
resource "aws_subnet" "ec2_private" {
  count             = length(var.ec2_private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.ec2_private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.project}-${var.env}-ec2-private-${count.index + 1}"
    Tier        = "Private-EC2"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}

# RDS Private subnets (2 subnets in 2 AZs for RDS subnet group)
resource "aws_subnet" "rds_private" {
  count             = length(var.rds_private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.rds_private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.project}-${var.env}-rds-private-${count.index + 1}"
    Tier        = "Private-RDS"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}


# Multiple NAT Gateways for high availability
resource "aws_eip" "nat" {
  count = local.nat_gateway_count
}

resource "aws_nat_gateway" "nat" {
  count         = local.nat_gateway_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.project}-${var.env}-nat-gw-${count.index + 1}"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }

  depends_on = [aws_internet_gateway.igw]
}


# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project}-${var.env}-public-rt"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}


resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# EC2 Private route tables (one per AZ for multiple NAT Gateways)
resource "aws_route_table" "ec2_private" {
  count  = length(aws_subnet.ec2_private)
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[count.index].id
    }
  }

  tags = {
    Name        = "${var.project}-${var.env}-ec2-private-rt-${count.index + 1}"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}

resource "aws_route_table_association" "ec2_private" {
  count          = length(aws_subnet.ec2_private)
  subnet_id      = aws_subnet.ec2_private[count.index].id
  route_table_id = aws_route_table.ec2_private[count.index].id
}

# RDS Private route tables (no internet access needed)
resource "aws_route_table" "rds_private" {
  count  = length(aws_subnet.rds_private)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.env}-rds-private-rt-${count.index + 1}"
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
  }
}

resource "aws_route_table_association" "rds_private" {
  count          = length(aws_subnet.rds_private)
  subnet_id      = aws_subnet.rds_private[count.index].id
  route_table_id = aws_route_table.rds_private[count.index].id
}
