resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  iam_instance_profile         = "bastion-ssm-role"   # 👈 your manually created profile name
  vpc_security_group_ids       = [aws_security_group.bastion_sg.id]
  associate_public_ip_address  = false

  tags = merge(
    var.common_tags,
    { Name = "bastion-ssm" }
  )
}
