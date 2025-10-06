terraform {
  backend "s3" {
    bucket = "soat-tfstate-bucket"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
