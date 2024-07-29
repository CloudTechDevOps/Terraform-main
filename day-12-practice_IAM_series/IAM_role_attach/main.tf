resource "aws_instance" "example_instance" {
  instance_type        = var.ec2_instance_type
  ami                  = var.image_id
  iam_instance_profile = data.aws_iam_instance_profile.existing_role.role_name
}
