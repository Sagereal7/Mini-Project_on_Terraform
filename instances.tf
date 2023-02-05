# Creating key pair

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.ssh_access_key
  public_key = file("${abspath(path.cwd)}/id_rsa.pub")
}


# creating instance 1

resource "aws_instance" "mini_terra1" {
  ami             = "ami-0d09654d0a20d3ae2"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.mini_terra_security_grp_rule.id]
  subnet_id       = aws_subnet.mini_terra_public_subnet1.id
  availability_zone = "eu-west-2a"
  tags = {
    Name   = "mini_terra_1"
    source = "terraform"
  }
}
# creating instance 2
 resource "aws_instance" "mini_terra2" {
  ami             = "ami-0d09654d0a20d3ae2"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.mini_terra_security_grp_rule.id]
  subnet_id       = aws_subnet.mini_terra_public_subnet2.id
  availability_zone = "eu-west-2b"
  tags = {
    Name   = "mini_terra_2"
    source = "terraform"
  }
}
# creating instance 3
resource "aws_instance" "mini_terra3" {
  ami             = "ami-0d09654d0a20d3ae2"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.mini_terra_security_grp_rule.id]
  subnet_id       = aws_subnet.mini_terra_public_subnet1.id
  availability_zone = "eu-west-2a"
  tags = {
    Name   = "mini_terra_3"
    source = "terraform"
  }
}

resource "local_file" "Ip_address" {
  filename = "/home/ayodejicloud/terraform/host-inventory"
  content  = <<EOT
${aws_instance.mini_terra1.public_ip}
${aws_instance.mini_terra2.public_ip}
${aws_instance.mini_terra3.public_ip}
  EOT
}