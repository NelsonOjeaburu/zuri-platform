resource "aws_secretsmanager_secret" "this" {
  for_each                = toset(var.secret_names)
  name                    = "${var.name}/${each.key}"
  recovery_window_in_days = 0
}
