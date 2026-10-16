variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "devops-cicd"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "admin_cidr" {
  description = "Your public IP address with /32, e.g. 203.0.113.10/32"
  type        = string
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "enable_eks" {
  type    = bool
  default = false
}

variable "eks_cluster_version" {
  type    = string
  default = "1.33"
}

variable "eks_node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "eks_desired_size" {
  type    = number
  default = 2
}

variable "eks_min_size" {
  type    = number
  default = 1
}

variable "eks_max_size" {
  type    = number
  default = 3
}

