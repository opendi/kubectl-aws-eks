#!/bin/sh

set -e

if [ -z ${KUBECTL_VERSION+x} ] ; then
  KUBECTL_VERSION=v1.25.0
fi
ARCH=$(uname -m)
case $ARCH in
"aarch64")
  ARCH=arm64
  ;;
*)
  ARCH=amd64
  ;;
esac

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

echo "Pulling kubectl for version $ARCH/$KUBECTL_VERSION"
    curl -sL -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/"$KUBECTL_VERSION"/bin/linux/$ARCH/kubectl && \
        chmod +x /usr/bin/kubectl
    echo "Using kubectl version: "
    kubectl version --output=yaml

sh -c "kubectl $*"
