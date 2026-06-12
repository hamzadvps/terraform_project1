provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "my_sg1" {
  name   = "terraform-my-sg1"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance1" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type
  key_name      = "ans_master"

  vpc_security_group_ids = [
    aws_security_group.my_sg1.id
  ]

  tags = {
    Name = "Terraform-Server"
  }
}
