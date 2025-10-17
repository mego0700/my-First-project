    # Define the AWS provider
    provider "aws" {
      region = "eu-west-3" # Replace with your desired AWS region
    }

    # Define the EC2 instance resource
    resource "aws_instance" "example_instance" {
      ami           = "ami-0809e1e48f650e1f9" # Replace with a valid AMI ID for your region
      instance_type = "t2.micro"
      tags = {
        Name = "MyTerraformInstance"
      }
    }