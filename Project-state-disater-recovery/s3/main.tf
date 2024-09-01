
resource "aws_s3_bucket" "primary" {
    provider = aws.east
  bucket = "primary-terraform-state-bucket"

}
resource "aws_s3_bucket_versioning" "primary-versioning" {
  bucket = aws_s3_bucket.primary.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "secondary" {
  provider = aws.west
  bucket   = "secondary-terraform-state-bucket"
  
}
resource "aws_s3_bucket_versioning" "secondary-versioning" {
    provider = aws.west
  bucket = aws_s3_bucket.secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name        = "s3-replication-policy"
  description = "Policy for S3 replication"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ]
        Resource = "arn:aws:s3:::primary-terraform-state-bucket/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "arn:aws:s3:::secondary-terraform-state-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

resource "aws_s3_bucket_replication_configuration" "primary_to_secondary" {
  bucket = aws_s3_bucket.primary.id

  role = aws_iam_role.replication_role.arn

  rule {
    id     = "ReplicationRule"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.secondary.arn
      storage_class = "STANDARD"
    }
    delete_marker_replication {
      status = "Enabled"
    }

  

    filter {
      prefix = ""
    }
  }
  depends_on = [ aws_s3_bucket_versioning.secondary-versioning ]
}




resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"
}
