variable "environment" {
    default = "dev"
}

variable "project_name" {
  default = "expense"
}

variable "common_tags" {
  default = {
    Environment = "dev"
    Project = "exense"
    Terraform = "true"
  }
}

variable "eks_tags" {
    default = {
        Component = "eks"
    }
  
}

variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}