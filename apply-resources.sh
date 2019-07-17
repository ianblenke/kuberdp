#!/bin/bash
set -eo pipefail

# Make sure commands that this script needs are available
which jq && which kubectl

# Prepare sane defaults
SPAWNER_IMAGE=${SPAWNER_IMAGE:-ianblenke/kuberdp-spawner}
DESKTOP_IMAGE=${DESKTOP_IMAGE:-ianblenke/kuberdp-kalidesktop}
RDP_USERNAME=${RDP_USERNAME:-rdp}
RDP_PASSWORD=${RDP_PASSWORD:-rdp}

export KUBE_NAMESPACE=${KUBE_NAMESPACE:-default}

kubectl get secret kuberdp-credentials --namespace ${KUBE_NAMESPACE} || \
kubectl create secret generic kuberdp-credentials \
    --namespace ${KUBE_NAMESPACE} \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

kubectl delete -n default deployment.apps/spawner || true

cat <<EOF | kubectl apply --namespace ${KUBE_NAMESPACE} -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kuberdp
  namespace: ${KUBE_NAMESPACE}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kuberdp
  namespace: ${KUBE_NAMESPACE}
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
  namespace: ${KUBE_NAMESPACE}
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
      serviceAccount: kuberdp
      serviceAccountName: kuberdp
      containers:
      - name: spawner
        ports:
        - containerPort: 3389
        env:
        - name: KUBE_NAMESPACE
          value: ${KUBE_NAMESPACE}
        - name: RDP_USERNAME
          value: ${RDP_USERNAME}
        - name: RDP_PASSWORD
          value: ${RDP_PASSWORD}
        image: ${SPAWNER_IMAGE}
        imagePullPolicy: Always
      imagePullSecrets:
      - name: kuberdp-credentials
---
apiVersion: v1
kind: Service
metadata:
  name: spawner-rdp
  namespace: ${KUBE_NAMESPACE}
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
  namespace: ${KUBE_NAMESPACE}
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
