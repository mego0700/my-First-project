terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# OPTION B: create AWS key pair from local public key file (uncomment if using)
# resource "aws_key_pair" "jenkins" {
#   key_name   = var.key_name
#   public_key = file("${path.module}/jenkins_key.pub")
# }

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http_${replace(timestamp(), "[:TZ-]", "")}"
  description = "Allow SSH (22) and HTTP (80) inbound"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_instance" "example_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  # If you used OPTION B (resource aws_key_pair.jenkins), use:
  # key_name = aws_key_pair.jenkins.key_name
  # If you created Key Pair in console (OPTION A), use var.key_name:
  key_name = var.key_name

  tags = {
    Name = "MyTerraformInstance"
  }
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.example_instance.public_ip
}
