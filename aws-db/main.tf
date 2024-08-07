provider "aws" {
  region     = "us-east-1"
} 

resource "aws_db_instance" "mydb" {
  identifier_prefix = "d"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  db_name = "mydatabase"
  engine_version         = "8.0"

  #Set username and password for the DB
  username = var.db_username
  password = var.db_password
}


terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-hessi-z-90"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

resource "aws_dynamodb_table" "terraform-locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-bucket-hessi-z-90"
  lifecycle {
    # Prevent accidental deletion of this S3 bucket
    #prevent_destroy = true
  }
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "my-state-versioning" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {

    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "my-encryption" {
  bucket = aws_s3_bucket.terraform-state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "my-public-block" {
  bucket                  = aws_s3_bucket.terraform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

/*
 export ENV variables for DB username and password
 export TF_VAR_db_username="username"
 export TF_VAR_db_password="your_password"

 for terraform backend export these
 export AWS_ACCESS_KEY_ID.
 export AWS_SECRET_ACCESS_KEY
*/
