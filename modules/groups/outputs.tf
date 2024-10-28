output "group_name_to_id" {
  value = {
    for group in vault_identity_group.admins : group.name => group.id
  }
}
