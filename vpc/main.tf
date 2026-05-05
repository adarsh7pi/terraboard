# vpc/main.tf — VPC, subnets, gateways, and route tables

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_count = min(length(var.public_subnet_cidrs), length(data.aws_availability_zones.available.names))
  azs      = slice(data.aws_availability_zones.available.names, 0, local.az_count)
}

## VPC
resource "aws_vpc" "this" {
  count                = module.this.enabled ? 1 : 0
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = merge(module.this.tags, { Name = module.this.id })
}

## Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = module.this.enabled ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  tags   = merge(module.this.tags, { Name = "${module.this.id}-igw" })
}

## Public Subnets
resource "aws_subnet" "public" {
  count                   = module.this.enabled ? local.az_count : 0
  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(module.this.tags, {
    Name = "${module.this.id}-public-${local.azs[count.index]}"
    Tier = "public"
  })
}

resource "aws_route_table" "public" {
  count  = module.this.enabled ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  tags   = merge(module.this.tags, { Name = "${module.this.id}-public-rt" })
}

resource "aws_route" "public_internet" {
  count                  = module.this.enabled ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = module.this.enabled ? local.az_count : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

## Private Subnets
resource "aws_subnet" "private" {
  count             = module.this.enabled ? local.az_count : 0
  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  tags = merge(module.this.tags, {
    Name = "${module.this.id}-private-${local.azs[count.index]}"
    Tier = "private"
  })
}

## NAT Gateway
resource "aws_eip" "nat" {
  count  = module.this.enabled && var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags   = merge(module.this.tags, { Name = "${module.this.id}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  count         = module.this.enabled && var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags          = merge(module.this.tags, { Name = "${module.this.id}-nat" })
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count  = module.this.enabled ? local.az_count : 0
  vpc_id = aws_vpc.this[0].id
  tags   = merge(module.this.tags, { Name = "${module.this.id}-private-rt-${local.azs[count.index]}" })
}

resource "aws_route" "private_nat" {
  count                  = module.this.enabled && var.enable_nat_gateway ? local.az_count : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  count          = module.this.enabled ? local.az_count : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
