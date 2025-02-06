locals {
  resource_name = "${var.project_name}-${var.environment}-eks"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  node_sg_id = data.aws_ssm_parameter.node_sg_id.value
  eks_control_plane_sg_id = data.aws_ssm_parameter.eks_control_plane_sg_id.value

}