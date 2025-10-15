resource "aws_vpc" "new_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    { Name = "vpc" }
  )
}

resource "aws_internet_gateway" "newvpcigw" {
  vpc_id = aws_vpc.new_vpc.id
  tags   = merge(var.common_tags, { Name = "igw" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    { Name = "public-${count.index + 1}" }
  )
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    { Name = "private-${count.index + 1}" }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.new_vpc.id
  tags   = merge(var.common_tags, { Name = "public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.newvpcigw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.new_vpc.id
  tags   = merge(var.common_tags, { Name = "private-rt" })
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
