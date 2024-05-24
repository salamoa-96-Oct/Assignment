module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                    = var.eks_name
  cluster_version                 = var.eks_version
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      service_account_role_arn = aws_iam_role.vpc_cni.arn
    }
  }

  vpc_id                   = data.terraform_remote_state.js_vpc.outputs.js_vpc_id
  subnet_ids               = [data.terraform_remote_state.js_vpc.outputs.js_private_subets_id]
  control_plane_subnet_ids = [data.terraform_remote_state.js_vpc.outputs.js_public_subets_id, data.terraform_remote_state.js_vpc.outputs.js_private_subets_id]
  create_cloudwatch_log_group = false
  # cluster_enabled_log_types = ["audit", "api", "authenticator", "controllerManager", "scheduler"]

  create_kms_key = true
  cluster_encryption_config = {
    resources= ["secrets"]
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["c6i.xlarge"]
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.xlarge"]
      capacity_type  = "SPOT"
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  # access_entries = {
  #   # One access entry with a policy associated
  #   example = {
  #     kubernetes_groups = ["system:masters"]
  #     principal_arn     = "arn:aws:iam::123456789012:role/something"
  #   }
  # }
  tags = {
    Environment = "test"
  }
}