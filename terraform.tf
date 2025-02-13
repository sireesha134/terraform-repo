# Provider configuration
provider "aws" {
  region = "us-west-2" 
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "sireesha-test" 
  acl    = "private"              

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
