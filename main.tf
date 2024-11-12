provider "vault" {}

locals {
  config = yamldecode(file("${path.module}/config.yaml"))
  oidc = try(yamldecode(file("${path.module}/oidc.auth.yaml")), {
    enabled = false
  })
}

module "policies" {
  source = "./modules/policies"
}

module "auth_backends" {
  source = "./modules/auth_backends"
  config = local.config
  oidc   = local.oidc
}

module "entities" {
  source   = "./modules/entities"
  entities = local.config.entities
}

# setup user logins
module "users" {
  depends_on         = [module.auth_backends, module.entities]
  source             = "./modules/users"
  config             = local.config
  users              = local.config.users
  user_pass_accessor = module.auth_backends.user_pass_accessor
  entity_name_to_id  = module.entities.entity_name_to_id
}

module "groups" {
  source            = "./modules/groups"
  config            = local.config
  entity_name_to_id = module.entities.entity_name_to_id
}

module "group_aliases" {
  source           = "./modules/group_aliases"
  config           = local.config
  group_name_to_id = module.groups.group_name_to_id
  oidc = local.oidc
  oidc_backend_accessor = module.auth_backends.oidc_backend_accessor
}

module "oidc" {
  source           = "./modules/oidc"
  config           = local.config
  group_name_to_id = module.groups.group_name_to_id
}
