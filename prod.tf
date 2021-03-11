provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "prod_tf_example" {
  bucket = "tf-example-20210311"
  acl    = "private"
}
  
resource "aws_default_vpc" "default" {}

