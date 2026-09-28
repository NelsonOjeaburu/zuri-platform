variable "name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "secret_id" {
  type = string
}

variable "backend_repo_url" {
  type = string
}

variable "health_check_script_url" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
