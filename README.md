# vault.idp

## Setup
```bash
# create .env file - to be read by go-task
cat <<EOF > terraform.auto.tfvars
oidc = {
  client_id = "..."
  client_secret = "..."
  discovery_url = "https://login.microsoftonline.com/.../v2.0"
  discovery_ca_file_path = "..."
}
EOF
```
- `task tf_apply` - sets up vault policy against VAULT_ADDR, using the currently configured token. Tested with a naughty ROOT_TOKEN.
- `task auth_apply` - configures kubernetes auth against VAULT_ADDR, using the CLIENT_KUBECONFIG  into the ${TF_VAR_client_test_kubernetes_namespace}
- `task tests_apply` - deploys the tests mentioned below into the ${TF_VAR_client_test_kubernetes_namespace}

