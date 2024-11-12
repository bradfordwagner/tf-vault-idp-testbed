variable "config" {
  type = any
}

variable "group_name_to_id" {
  type = map(string)
}

variable "oidc" {
  type = any
}

variable "oidc_backend_accessor" {
  type = string
}
