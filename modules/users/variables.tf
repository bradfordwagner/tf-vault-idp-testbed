variable "config" {
  type = any
}

variable "users" {
  # username -> {password}
  type = any
}

variable "user_pass_accessor" {
  type = string
}

variable "entity_name_to_id" {
  type = map(string)
}
