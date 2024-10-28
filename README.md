# vault.idp

## Setup
```bash
# create .env file - to be read by go-task
cat <<EOF > .env
export VAULT_ADDR=...
export VAULT_FORMAT=json
export CLIENT_KUBECONFIG=... # full path to kubeconfig
export TF_VAR_client_test_kubernetes_namespace=...
export IMAGE=... # threaded through to helm
EOF
```
- `task tf_apply` - sets up vault policy against VAULT_ADDR, using the currently configured token. Tested with a naughty ROOT_TOKEN.
- `task auth_apply` - configures kubernetes auth against VAULT_ADDR, using the CLIENT_KUBECONFIG  into the ${TF_VAR_client_test_kubernetes_namespace}
- `task tests_apply` - deploys the tests mentioned below into the ${TF_VAR_client_test_kubernetes_namespace}

