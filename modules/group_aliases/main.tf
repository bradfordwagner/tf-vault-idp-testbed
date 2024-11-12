resource "vault_identity_group_alias" "identities" {
  for_each = var.oidc.roles
  name = each.value.idp_group
  mount_accessor = var.oidc_backend_accessor
  canonical_id = var.group_name_to_id[each.value.group]
}
