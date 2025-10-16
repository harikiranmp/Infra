# Bastion Security Group - allows only outbound to VPC
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

# IAM Role for Bastion to use SSM
resource "aws_iam_role" "bastion_role" {
  name = "bastion-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach SSM Managed Policy
resource "aws_iam_role_policy_attachment" "bastion_ssm_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-ssm-profile"
  role = aws_iam_role.bastion_role.name
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

# Bastion EC2 instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  iam_instance_profile         = aws_iam_instance_profile.bastion_profile.name
  vpc_security_group_ids       = [aws_security_group.bastion_sg.id]
  associate_public_ip_address  = false  # No public IP

  tags = merge(
    var.common_tags,
    { Name = "bastion-ssm" }
  )
}
