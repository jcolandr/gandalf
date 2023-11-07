
# resource "aws_s3_bucket" "mongo_backups" {
#   bucket = "your-mongodb-backups-bucket-name" # Replace with your desired bucket name
#   acl    = "public-read"
# }

# output "s3_bucket_name" {
#   value = aws_s3_bucket.mongo_backups.id
# }

resource "aws_s3_bucket" "mongo-backups" {
  bucket = "my-tf-mongo-backups-bucket"
}

resource "aws_s3_bucket_ownership_controls" "mongo-backups" {
  bucket = aws_s3_bucket.mongo-backups.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "mongo-backups" {
  bucket = aws_s3_bucket.mongo-backups.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "mongo-backups" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mongo-backups,
    aws_s3_bucket_public_access_block.mongo-backups,
  ]

  bucket = aws_s3_bucket.mongo-backups.id
  acl    = "public-read"
}