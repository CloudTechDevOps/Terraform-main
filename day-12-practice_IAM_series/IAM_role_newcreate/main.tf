### Create IAM policy
resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  description = "Permissions for EC2"
  policy      = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Action: "ec2:*",
            Effect: "Allow",
            Resource: "*"
        }
      ]
    })
}

### Create IAM role
resource "aws_iam_role" "example_role" {
  name = "example_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "examplerole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

### Attach IAM policy to IAM role
resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "example_policy_attachment"
  roles      = [aws_iam_role.example_role.name]
  policy_arn = aws_iam_policy.example_policy.arn
}

### Create instance profile using role
resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example_role.name
}

### Create EC2 instance and attache IAM role
resource "aws_instance" "example_instance" {
  instance_type        = var.ec2_instance_type
  ami                  = var.image_id
  iam_instance_profile = aws_iam_instance_profile.example_profile.name
}
