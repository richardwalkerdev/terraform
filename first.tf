provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "tf_test" {
  bucket = "tf-test-20210311"
  acl    = "private"
}
  
