#!/bin/bash
set -eo pipefail

# Make sure commands that this script needs are available
which jq && which kubectl

# Prepare sane defaults
SPAWNER_IMAGE=${SPAWNER_IMAGE:-ianblenke/kuberdp-spawner}
KUBE_CONFIG_BASE64=$(kubectl config view --flatten --minify=true | openssl base64 -A)

kubectl get secret kuberdp-credentials || \
kubectl create secret generic kuberdp-credentials \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

set -eo pipefail

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spawner
  labels:
    app: spawner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spawner
  template:
    metadata:
      labels:
        app: spawner
    spec:
      containers:
      - name: spawner
        ports:
        - containerPort: 3389
        env:
        - name: KUBE_CONFIG_BASE64
          value: ${KUBE_CONFIG_BASE64}
        image: ${SPAWNER_IMAGE}
        imagePullPolicy: Always
      imagePullSecrets:
      - name: kuberdp-credentials
---
apiVersion: v1
kind: Service
metadata:
  name: spawner-rdp
spec:
  type: NodePort
  selector:
    app: spawner
  ports:
  - protocol: TCP
    port: 30389
    nodePort: 30389
    targetPort: 3389
---
apiVersion: v1
kind: Service
metadata:
  name: spawner-echo
spec:
  type: NodePort
  selector:
    app: spawner
  ports:
  - protocol: TCP
    port: 30007
    nodePort: 30007
    targetPort: 7
EOF
