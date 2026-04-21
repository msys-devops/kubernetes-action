#!/bin/sh -l
echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG=kubeconfig
result=$(sh -c "kubectl $1")
status=$?

# Handle multiline output safely
delimiter="EOF_$(date +%s)"
{
  echo "result<<${delimiter}"
  echo "$result"
  echo "${delimiter}"
} >> "$GITHUB_OUTPUT"

echo "$result"