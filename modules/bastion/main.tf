resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for SSM bastion host"
  vpc_id      = var.vpc_id

  # No inbound rule (no SSH port open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    { Name = "bastion-sg" }
  )
}

# Fetch latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  iam_instance_profile         = "bastion-ssm-role"  
  vpc_security_group_ids       = [aws_security_group.bastion_sg.id]
  associate_public_ip_address  = false

  tags = merge(
    var.common_tags,
    { Name = "bastion-ssm" }
  )
}
