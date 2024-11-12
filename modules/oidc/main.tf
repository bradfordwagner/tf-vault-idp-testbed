locals {
  client_to_group_ids = {
    for client_name, client_values in var.config.oidc.clients : client_name => [
      for group_name in client_values.allowed_groups : var.group_name_to_id[group_name]
    ]
  }
}

# controls which groups can access the oidc client
resource "vault_identity_oidc_assignment" "assignments" {
  for_each  = var.config.oidc.clients
  name      = each.key
  group_ids = local.client_to_group_ids[each.key]
}

# configure oidc clients to access oidc provider
resource "vault_identity_oidc_client" "clients" {
  for_each      = var.config.oidc.clients
  name          = each.key
  redirect_uris = each.value.redirect_uris
  assignments = [vault_identity_oidc_assignment.assignments[each.key].name]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

# allow custom configuration of scope claims
# based on templates
resource "vault_identity_oidc_scope" "scopes" {
  for_each = var.config.oidc.scopes
  name        = each.key
  template    = each.value.template
  description = each.value.description
}

# setup oidc provider
resource "vault_identity_oidc_provider" "provider" {
  depends_on = [ vault_identity_oidc_client.clients, vault_identity_oidc_scope.scopes ]
  for_each = var.config.oidc.providers
  name = each.key
  https_enabled = true
  issuer_host = "vault.multitenant.hal.adpe-vault.extdns.dev.blackrock.com"
  # issuer_host = "vault-ui.vault.svc"
  allowed_client_ids = [
    for client_name in each.value.clients : vault_identity_oidc_client.clients[client_name].client_id
  ]
  scopes_supported =  each.value.scopes
}

