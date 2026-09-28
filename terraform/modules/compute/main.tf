data "aws_region" "current" {}

# Always pick the latest Amazon Linux 2023 image instead of hard-coding an ID.
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true

  # Require IMDSv2, a safer way for the server to ask AWS about itself.
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 8
  }

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    secret_id               = var.secret_id
    region                  = data.aws_region.current.name
    backend_repo_url        = var.backend_repo_url
    health_check_script_url = var.health_check_script_url
  })
  user_data_replace_on_change = true

  tags = { Name = "${var.name}-app" }
}
