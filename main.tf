resource "aws_vpc" "vpc0" {
  cidr_block       = "192.168.1.0/24"
  tags = {
    name = "vpc0"
  }
}

resource "aws_subnet" "sub0" {
  vpc_id = aws_vpc.vpc0.id
  cidr_block = "192.168.1.0/25"
  availability_zone = "us-east-1f"
}

resource "aws_security_group" "secg0" {
  vpc_id      = aws_vpc.vpc0.id
  egress      = [
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress     = [
    {
      cidr_blocks      = [
        "78.29.147.32/32",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  name        = "secg0"

}

resource "aws_instance" "winskills0" {
  depends_on = [ aws_security_group.secg0 ]
  ami                                  = "ami-08ed5c5dd62794ec0"
  associate_public_ip_address          = true
#  availability_zone                    = "us-east-1f"
  instance_type                        = "t2.small"
  key_name                             = "GRSI"
  subnet_id = aws_subnet.sub0.id

  vpc_security_group_ids = [
    aws_security_group.secg0.id,
  ]
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 100
    tags                  = {}
    throughput            = 0
    volume_size           = 30
  }

}

resource "aws_eip" "eip0" {
  instance = aws_instance.winskills0.id
  vpc = true
}