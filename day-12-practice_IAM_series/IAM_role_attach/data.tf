data "aws_iam_instance_profile" "existing_role" {
  name = var.role_name
}
