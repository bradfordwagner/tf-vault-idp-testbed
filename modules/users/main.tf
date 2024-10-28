resource "vault_generic_endpoint" "user" {
  for_each             = var.users
  path                 = "auth/userpass/users/${each.key}"
  ignore_absent_fields = true
  # "policies": ["default"],
  data_json = <<EOT
{
  "password": "${each.value.password}"
}
EOT
}

resource "vault_identity_entity_alias" "user_pass" {
  for_each = var.users
  # i think this needs to match the username
  # in order to not auto deploy an entity
  name           = each.key
  canonical_id   = var.entity_name_to_id[each.key]
  mount_accessor = var.user_pass_accessor
}

# # set up identity groups
# resource "vault_identity_group" "admins" {
#   name     = "admins"
#   type     = "internal"
#   policies = ["default"]
#   metadata = {
#     version = "2"
#   }
#   member_entity_ids = [
#     for id in [vault_identity_entity.user.id] : id if var.config.user.group == "admins"
#   ]
# }
# resource "vault_identity_group" "users" {
#   name     = "users"
#   type     = "internal"
#   policies = ["default"]
#   metadata = {
#     version = "2"
#   }
#   member_entity_ids = [
#     for id in [vault_identity_entity.user.id] : id if var.config.user.group == "users"
#   ]
# }

