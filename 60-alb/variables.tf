variable "environment" {
    default = "dev"
}

variable "project_name" {
    default = "expense"
}

variable "common_tags" {
    default = {
        project = "expense"
        Environment = "dev"
        Terraform = true
    }
}

variable "ingress_alb_tags" {
    default = {
        Component = "ingress_alb"
    }
}

variable "zone_name" {
   default = "vasavi.online"
}

