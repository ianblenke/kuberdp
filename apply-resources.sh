#!/bin/bash
set -eo pipefail

# Make sure commands that this script needs are available
which jq && which kubectl

# Prepare sane defaults
SPAWNER_IMAGE=${SPAWNER_IMAGE:-ianblenke/kuberdp-spawner}

kubectl get secret kuberdp-credentials || \
kubectl create secret generic kuberdp-credentials \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

set -eo pipefail

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kuberdp
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kuberdp
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: kuberdp
    namespace: default
---
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
      automountServiceAccountToken: true
      serviceAccount: spawner
      serviceAccountName: spawner
      containers:
      - name: spawner
        ports:
        - containerPort: 3389
        env:
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
