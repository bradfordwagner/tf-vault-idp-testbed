output "group_name_to_id" {
  value = {
    for group in vault_identity_group.groups : group.name => group.id
  }
}
