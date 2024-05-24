locals {
  eks_oidc_issuer_id = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
  oidc_provider_arn  = module.eks.oidc_provider_arn
}

data "aws_iam_policy" "cni" {
  name = "AmazonEKS_CNI_Policy"
}

resource "aws_iam_role" "vpc_cni" {
  name = var.vpc_cni_role_name

  assume_role_policy = templatefile("${path.module}/vpc-cni-iam.json.tmpl", {
    federated          = local.oidc_provider_arn
    eks_oidc_issuer_id = local.eks_oidc_issuer_id
  })
}

resource "aws_iam_role_policy_attachment" "vpc_cni_attachment" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = data.aws_iam_policy.cni.arn
}
