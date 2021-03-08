provider "aws" { region = "us-east-1" }

terraform {
  backend "s3" {
    region  = "us-east-1"
    encrypt = true
    bucket  = "test-state-tf-sonny-stacklet"
    key     = "stacklet-installer-ecr-policy-state"
  }
}
