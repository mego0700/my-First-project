variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "ami_id" {
  type    = string
  default = "ami-0809e1e48f650e1f9" 
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "jenkins-key" 
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"] 
}
