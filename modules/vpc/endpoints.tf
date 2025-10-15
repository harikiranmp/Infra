# --- Security group for interface endpoints ---
resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "vpc-endpoints-sg"
  description = "Allow HTTPS traffic for VPC interface endpoints"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.new_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-sg"
  }
}

# --- Interface Endpoints ---
locals {
  interface_endpoints = [
    "com.amazonaws.ap-south-1.sts",
    "com.amazonaws.ap-south-1.ecr.api",
    "com.amazonaws.ap-south-1.ecr.dkr",
    "com.amazonaws.ap-south-1.eks",
    "com.amazonaws.ap-south-1.ec2",
    "com.amazonaws.ap-south-1.logs"
  ]
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = toset(local.interface_endpoints)

  vpc_id             = aws_vpc.new_vpc.id
  service_name       = each.value
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  private_dns_enabled = true

  tags = {
    Name = replace(each.value, "com.amazonaws.ap-south-1.", "")
  }
}

# --- Gateway Endpoint for S3 ---
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.new_vpc.id
  service_name      = "com.amazonaws.ap-south-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name = "s3-endpoint"
  }
}
