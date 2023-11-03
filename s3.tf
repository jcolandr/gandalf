
resource "aws_s3_bucket" "mongo_backups" {
  bucket = "your-mongodb-backups-bucket-name" # Replace with your desired bucket name
  acl    = "public-read"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.mongo_backups.id
}
