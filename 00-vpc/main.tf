module "vpc" {
    source = "git::https://github.com/vasavithanniru/terraform-aws-vpc.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_cidr = var.vpc_cidr
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    common_tags = var.common_tags
    is_peering_required = var.is_peering_required
}