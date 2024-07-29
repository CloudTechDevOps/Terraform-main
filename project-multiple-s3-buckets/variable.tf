variable "s3_bucket_names" {
  type = list
  default = ["dev-bucket.app", "uat-bucket.app", "prod-bucket.app"]
}