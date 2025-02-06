resource "aws_key_pair" "eks" {
  key_name   = "eks"
  # public_key = file("~/.ssh/eks.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGWY54Wbw4089PrMtJksUGfjY94feMUkW+ZuOTFP+YGWX+FliuS4v26zeQLJNVxc7N23uJFRE3Sg4m5+MJdlzRHCeNgk0O/j1PUi7bnwGDmPTljNqdDSraNZVcQ1MQYXh01uBCwXAB9cjNVIoKbWpXTwz3HmqkjGebvGRZUXmhHN+IadenBIRFEKAOMi8QZkv08eBhHd40g13oyZeOBqbsgrR6TbdkRAPfMV8daD/W7eS1A+bbx62u5PeH0N57PrVw8KDjlX0Rr7NOtK17M9in5kYLhuLkBjZNlAz3iKW34H2XgrmDlcSJWtEDiK+XimtC5hJX0b5pC9/4fDUlaaX+cCNC9gFUUu/BPgimVxhHXWwMPN8t1f+4qfVId47pSBEaXZsMlErOOV6eAIR5utX4pHkWvkuBY5KrhtivqQ8E4RSJyRQlpf3glxR/14uORcdyXcR783l1/bLlRBowRV5NeXDUvLWYwskAOps0c2l6urqNIWp6IacpC1y0LE7zuys= DELL@DESKTOP-LAT2UG4"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  

  cluster_name    = local.resource_name
  cluster_version = "1.31"  # we are going to upgrade from 1.30 to 1.31

  
  # Optional
  cluster_endpoint_public_access = true  #if false we need to give acces through vpn   

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_cluster_security_group = false 
  cluster_security_group_id = local.eks_control_plane_sg_id

  create_node_security_group = false 
  node_security_group_id = local.node_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    # blue = {
    #   min_size     = 2
    #   max_size     = 10
    #   desired_size = 2
    #   iam_role_additional_policies = {
    #     AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
    #     ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #   }
    #   # EKS takes AWS Linux 2 as it's OS to the nodes
    #   key_name = aws_key_pair.eks.key_name
    # }

    green = {
      min_size      = 2
      max_size      = 10
      desired_size  = 2
      #capacity_type = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
      # EKS takes AWS Linux 2 as it's OS to the nodes
      key_name = aws_key_pair.eks.key_name
    }

  }
  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  tags = var.common_tags
}