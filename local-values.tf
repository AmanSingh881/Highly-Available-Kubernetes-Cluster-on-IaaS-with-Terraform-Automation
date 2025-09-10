# Define Local Values in Terraform
locals {
  owners = "terraform"
  environment = "Dev"
  # name = "${var.business_divsion}-${var.environment}"
  name = "${local.owners}-${local.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}