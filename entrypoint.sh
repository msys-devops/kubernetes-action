#!/bin/sh -l

if [ -z "$KUBE_CONFIG_DATA" ]; then
  echo "::error::KUBE_CONFIG_DATA secret is not set" >&2
  exit 1
fi

if [ -z "$1" ]; then
  echo "::error::No kubectl command provided" >&2
  exit 1
fi

echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG=kubeconfig

result=$(sh -c "kubectl $1" 2>&1)
status=$?

echo "$result"

# Detect the specific auth error and give devs a clear message
if echo "$result" | grep -q 'client.authentication.k8s.io/v1alpha1'; then
  echo "::error::Kubeconfig uses deprecated v1alpha1 auth API. The KUBE_CONFIG_DATA secret for this project needs to be regenerated with a current AWS CLI. Contact the devops team." >&2
  exit 1
fi

if [ -n "$GITHUB_OUTPUT" ]; then
  delimiter="EOF_$(date +%s)"
  {
    echo "result<<${delimiter}"
    echo "$result"
    echo "${delimiter}"
  } >> "$GITHUB_OUTPUT"
fi

exit $status