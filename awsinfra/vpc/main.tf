## VPC ##

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name        = "js-vpc"
    Environment = "test"
  }
}

## Subnet - public ##

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = var.region_az_a
  map_public_ip_on_launch = true

  tags = {
    Name        = "js-test-public-subnet-a"
    Environment = "test"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.js_cluster_name}"  = "shared"
  }
}
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.3.0/24"
  availability_zone       = var.region_az_c
  map_public_ip_on_launch = true

  tags = {
    Name        = "js-test-public-subnet-c"
    Environment = "test"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.js_cluster_name}"  = "shared"
  }
}

## Subnet - private ##

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = var.region_az_c
  map_public_ip_on_launch = true

  tags = {
    Name        = "js-test-private-subnet-a"
    Environment = "test"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.js_cluster_name}"  = "shared"
  }
}
resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.4.0/24"
  availability_zone       = var.region_az_c
  map_public_ip_on_launch = true

  tags = {
    Name        = "js-test-private-subnet-c"
    Environment = "test"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.js_cluster_name}"  = "shared"
  }
}

## IGW ##

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "js-igw"
    Environment = "test"
  }
}

## Route Table ##

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "js-test-public-rt"
    Environment = "test"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat.id
  }
  tags = {
    Name = "js-test-private-rt"
    Environment = "test"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

## NAT Gateway ##
resource "aws_eip" "eip-natgateway" {
  vpc = true
  tags = {
    "Name" = "js-test-nat-gateway-eip"
    Environment = "test"
  }
}
resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.eip-natgateway.id
  subnet_id     = aws_subnet.public.id
  tags = {
    "Name" = "js-natgateway"
    Environment = "test"
  }
}