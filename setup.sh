#!/bin/bash
#kubectl create namespace istio-system
#helm install istio-base istio/base -n istio-system
#helm install istiod istio/istiod -n istio-system --wait
#kubectl create namespace istio-ingress
#helm install istio-ingress istio/gateway -n istio-ingress

istioctl install --set profile=demo -y

kubectl label namespace default istio-injection=enabled

kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml


kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.18.255.1-172.18.255.250
EOF
