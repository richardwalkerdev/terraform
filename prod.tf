variable "web_image_id" {
  type = string
}

variable "web_instance_type" {
  type = string
}

variable "whitelist" {
  type = list(string)
}


provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "prod_tf_example" {
  bucket = "tf-example-20210311"
  acl    = "private"
}
  
resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_azb" {
  availability_zone = "eu-west-2b"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_azc" {
  availability_zone = "eu-west-2c"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow http and https ports inbound and outbound"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.whitelist
  }
  
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_instance" "prod_web" {
  count = 2

  ami           = var.web_image_id
  instance_type = var.web_instance_type
  
  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip_association" "prod_web" {
  instance_id   = aws_instance.prod_web.0.id
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prod_web" {
  name            = "prod-web" 
  instances       = aws_instance.prod_web.*.id
  subnets         = [aws_default_subnet.default_azb.id, aws_default_subnet.default_azc.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  tags = {
    "Terraform" : "true"
  }

}
