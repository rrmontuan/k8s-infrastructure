resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/24"
  
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.public_subnets_cidr)

  tags = {
    Name        = "${var.environment}-public-route-table-${count.index}"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
  count                  = length(var.public_subnets_cidr)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_security_group" "external_access" {
  name        = "${var.environment}-external_access-sg"
  description = "Security group to handle external access"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "TCP"
    description   = "SSH Access"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "TCP"
    description   = "HTTP Access"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "TCP"
    description   = "HTTPS Access"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "External Access"
    Environment = var.environment
  }
}

resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    description   = "All Ingress Access between this security group"
    self          = true   
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    description   = "All External Access"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "Default"
    Environment = var.environment
  }
}
