terraform {
  required_version = ">= 1.3.0"
}
terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}