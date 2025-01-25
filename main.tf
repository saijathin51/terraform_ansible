provider "aws" {
  region     = var.AWS_DEFAULT_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}


resource "aws_security_group" "nginx_sg" {
  name        = "nginx-security-group"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "nginx_server" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "ec2_key"

  security_groups = [aws_security_group.nginx_sg.name]

  tags = {
    Name = "NginxServer"
  }
}

output "instance_ip" {
  value = aws_instance.nginx_server.public_ip
}
variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
  type        = string
}

variable "AWS_DEFAULT_REGION" {
  description = "The AWS region"
  type        = string
}
