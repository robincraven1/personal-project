provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "nextwork-terraform-tutorial-bucket-robin"
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "image_for_terraform_tutorial" {
  bucket = aws_s3_bucket.my_bucket.id # Reference the bucket ID
  key    = "image_for_terraform_tutorial.png" # Path in the bucket
  source = "image_for_terraform_tutorial.png" # Local file path
}

resource "aws_s3_object" "GLACIERRRR_image_for_terraform_tutorial" {
  bucket = aws_s3_bucket.my_bucket.id # Reference the bucket ID
  key    = "GLACIER_image_for_terraform_tutorial.png" # Path in the bucket
  source = "GLACIER_image_for_terraform_tutorial.png" # Local file path

  storage_class = "GLACIER"
}