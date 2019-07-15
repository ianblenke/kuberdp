#!/bin/bash
set -exo pipefail

# Make sure commands that this script needs are available
which jq && which kubectl

# Prepare sane defaults
SPAWNER_IMAGE=${SPAWNER_IMAGE:-ianblenke/kuberdp-spawn}
DOCKER_CONFIG_JSON_BASE64=$(jq -c . ~/.docker/config.json | openssl base64 -A)
KUBE_CONFIG_BASE64=$(kubectl config view --flatten --minify=true | openssl base64 -A)

set -eo pipefail

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: kuberdp-credentials
data:
  .dockerconfigjson: "${DOCKER_CONFIG_JSON_BASE64}"
type: kubernetes.io/dockerconfigjson
EOF

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
      - env:
        - name: KUBE_CONFIG_BASE64
          value: ${KUBE_CONFIG_BASE64}
        - name: KUBE_NAMESPACE
          value: ${KUBE_NAMESPACE}
        - name: DOCKER_CONFIG_JSON
          valueFrom:
            secretKeyRef:
              name: kuberdp-credentials
              key: .dockerconfigjson
        name: spawner
        image: ${SPAWNER_IMAGE}
        ports:
        - containerPort: 3389
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
