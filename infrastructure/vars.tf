variable "AWS_REGION" {
  default = "us-east-1"
}

variable "base_domain" {
  default = "cyntaax.dev"
}

variable "sub_domain" {
  default = "minecraft"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}