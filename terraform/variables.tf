variable "wanderlust_project_name" {
  description = "The name of the Wanderlust project"
  type        = string
  default     = "wanderlust"
  
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "wanderlust_vpc"
  
}

variable "public_key_path" {
  description = "Path to the public key for SSH access"
  type        = string
  default     = "~/.ssh/wanderlust.pub"
  
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
  
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}