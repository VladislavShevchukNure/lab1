terraform {

required_providers {
		aws = {
		source = "hashicorp/aws"
		version = "~> 4.0"
		}
	}
}

# Configure AWS provider and creds
provider "aws" {
	region = "us-east-1"
}

# Creating bucket
resource "aws_s3_bucket" "website" {
	bucket = "terraform-bucket-shevchuk"
	tags = {
		Name = "Website"
		Environment = "Dev"
	}
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_website_configuration" "website_config" {
	bucket = aws_s3_bucket.website.id
	index_document {
		suffix = "index.html"
	}
	error_document {
		key = "error.html"
	}
}
	#policy = data.aws_iam_policy_document.allow_access.json
	#arn:aws:s3:::terraform-bucket-shevchuk3/*
resource "aws_s3_bucket_policy" "allow_access" {
	bucket = aws_s3_bucket.website.id
	policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	  "Principal": "*",
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.website.arn}",
        "${aws_s3_bucket.website.arn}/*"
      ]
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "allow_access" {
	statement {
		principals {
			type = "AWS"
			identifiers = ["*"]
		}
		actions = [ "s3:GetObject" ]
		resources = [ aws_s3_bucket.website.arn,
		"${aws_s3_bucket.website.arn}/*", ]
	}
}

resource "aws_s3_object" "indexfile" {
	bucket = aws_s3_bucket.website.id
	key = "index.html"
	source = "./src/index.html"
	content_type = "text/html"
}

output "website_endpoint" {
	value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
