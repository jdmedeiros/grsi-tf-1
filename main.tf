variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
  default     = "vpc-0d5dcbf472763c928"
}

data "aws_vpc" "target" {
  id = var.vpc_id
}

resource "aws_eip" "eip0" {
  network_border_group = "us-east-1"
  tags                 = {}
  tags_all             = {}
  vpc                  = true

  timeouts {}
}

# aws_security_group.sg0:
resource "aws_security_group" "sg0" {
  description = "Grupo de seguranca para o exercicio um"
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
        "0.0.0.0/0",
      ]
      description      = "Permitir todo o iCMP"
      from_port        = -1
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "icmp"
      security_groups  = []
      self             = false
      to_port          = -1
    },
    {
      cidr_blocks      = [
        "78.29.147.32/32",
      ]
      description      = "Permitir todo o DNS vindo do meu IP"
      from_port        = 53
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "udp"
      security_groups  = []
      self             = false
      to_port          = 53
    },
    {
      cidr_blocks      = [
        "78.29.147.32/32",
      ]
      description      = "Permitir todo o HTTPS vindo do meu IP"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks      = []
      description      = "Permitir todo o HTTP vindo de IPv6"
      from_port        = 80
      ipv6_cidr_blocks = [
        "::/0",
      ]
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
  ]
  name        = "grsi-security-group"
  tags        = {}
  tags_all    = {}

  vpc_id = data.aws_vpc.target.id
  timeouts {}
}

# aws_instance.instance0:
resource "aws_instance" "instance0" {
  ami                                  = "ami-0f9fc25dd2506cf6d"
  instance_type                        = "t2.micro"
  key_name                             = "GRSI"
  subnet_id                            = "subnet-01456de77f953cad1"
  vpc_security_group_ids               = [
    aws_security_group.sg0.id,
  ]

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdb"
    volume_size           = 12
    volume_type           = "gp3"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }
}

# aws_eip_association.eip0_assoc:
resource "aws_eip_association" "eip0_assoc" {
  allocation_id        = aws_eip.eip0.id
  instance_id          = aws_instance.instance0.id
}