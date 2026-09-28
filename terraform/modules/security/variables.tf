variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "secret_arns" {
  type = list(string)
}
