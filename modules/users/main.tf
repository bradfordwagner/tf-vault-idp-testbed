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
