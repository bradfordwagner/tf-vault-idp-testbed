# # set up identity groups
resource "vault_identity_group" "groups" {
  for_each = var.config.groups
  name     = each.key
  type     = each.value.type
  policies = each.value.policies
  # member_entity_ids = [
  #   for entity_name in each.value.entity_names : var.entity_name_to_id[entity_name]
  # ]
}

