terraform {
  backend "s3" {
    bucket = "my-eks-cicd-7001"
    key = "eks/terraform.tfstate"
    region = "ap-southeast-1"
  }
}