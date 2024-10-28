output "entity_name_to_id" {
  value = {
    for entity in vault_identity_entity.entity : entity.name => entity.id
  }
}
