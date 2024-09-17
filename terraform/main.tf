# Création du bucket S3
resource "aws_s3_bucket" "website_bucket" {
  bucket = "lecloudfacile-myname"  # Remplacez par un nom unique
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "website" {
  
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Politique du bucket pour permettre l'accès public en lecture
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      },
    ]
  })
}

# Output pour afficher l'URL du site web
output "website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}