#LIBRERIA

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.36.1"
    }
  }
  backend "s3" {
    
  }
}

#PROVIDER
provider "aws" {
  region = var.region #"eu-west-1"
}

#BUCKET
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.aws_s3_bucket}-${random_string.texto.result}-${var.aws_s3_bucket_env}"
}

# RANDOM TEXT
resource "random_string" "texto" {
  length = 5 
  special = false
  upper = false
}