terraform {
  backend "s3" {
    bucket = "fiap-soat-tc-terraform"
    key    = "tc3/terraform.tfstate"
    region = "us-east-1"
  }
}
