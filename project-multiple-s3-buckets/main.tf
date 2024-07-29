resource "aws_s3_bucket" "test_buckets" {
  count         = length(var.s3_bucket_names) //count will be 3
  bucket        = var.s3_bucket_names[count.index]
  force_destroy = true
}