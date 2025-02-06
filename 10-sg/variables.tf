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

variable "mysql_sg_tags" {
    default = {
        Component = "mysql"
    }
}

variable "eks_control_plane_sg_tags" {
    default = {
        Component = "eks-control-plane"
    }
}

variable "node_sg_tags" {
    default = {
        Component = "node-group"
    }
}

variable "ingress_alb_sg_tags" {
    default = {
        Component = "ingress-alb"
    }
}

variable "bastion_sg_tags" {
    default = {
        Component = "bastion"
    }
}

