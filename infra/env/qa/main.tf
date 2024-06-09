provider "aws" {
  region = var.region
  default_tags {
    tags = local.tags
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
