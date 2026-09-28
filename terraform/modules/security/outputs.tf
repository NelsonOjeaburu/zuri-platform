output "security_group_id" {
  value = aws_security_group.app.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.app.name
}
