#!/bin/bash
set -eo pipefail

export $(cat /.env)

PORT=${PORT:-3389}
DESKTOP_IMAGE=${DESKTOP_IMAGE:-ianblenke/kuberdp-desktop}
RDP_USERNAME=${RDP_USERNAME:-rdp}
RDP_PASSWORD=${RDP_PASSWORD:-rdp}

# Uniquely name each deployment/service
PID=$$
NAME=kuberdp-desktop-$PID

# Clean up gracefully
_term() { 
  kubectl delete deployment/$NAME >> /tmp/$NAME 2>&1
  kubectl delete service/$NAME >> /tmp/$NAME 2>&1
}

trap _term SIGTERM SIGINT

# Spawn a new container
kubectl apply -f - > /tmp/$NAME 2>&1 <<EOF
## Allow for AzureFile attached PVC from Azure Storage Account File Share
## TODO: FIXME: This currently results in a black screen on subsequent connections.
#kind: StorageClass
#apiVersion: storage.k8s.io/v1
#metadata:
#  name: azurefile
#provisioner: kubernetes.io/azure-file
#mountOptions:
#  - dir_mode=0777
#  - file_mode=0777
#  - uid=1000
#  - gid=1000
#parameters:
#  skuName: Standard_LRS
#---
#apiVersion: rbac.authorization.k8s.io/v1
#kind: ClusterRole
#metadata:
#  name: system:azure-cloud-provider
#rules:
#- apiGroups: ['']
#  resources: ['secrets']
#  verbs:     ['get','create']
#---
#apiVersion: rbac.authorization.k8s.io/v1
#kind: ClusterRoleBinding
#metadata:
#  name: system:azure-cloud-provider
#roleRef:
#  kind: ClusterRole
#  apiGroup: rbac.authorization.k8s.io
#  name: system:azure-cloud-provider
#subjects:
#- kind: ServiceAccount
#  name: persistent-volume-binder
#  namespace: kube-system
#---
#apiVersion: v1
#kind: PersistentVolumeClaim
#metadata:
#  name: sharedhome
#spec:
#  accessModes:
#    - ReadWriteMany
#  storageClassName: azurefile
#  resources:
#    requests:
#      storage: 5Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $NAME
  labels:
    app: $NAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $NAME
  template:
    metadata:
      labels:
        app: $NAME
    spec:
      ## Allow the use of a private container registry for images
      imagePullSecrets:
      - name: kuberdp-credentials
      containers:
      - name: desktop
        image: $DESKTOP_IMAGE
        ports:
        - containerPort: $PORT
        securityContext:
          privileged: true
        env:
        - name: RDP_USERNAME
          value: ${RDP_USERNAME}
        - name: RDP_PASSWORD
          value: ${RDP_PASSWORD}
## TODO: FIXME: This currently results in a black screen on subsequent connections.
#        volumeMounts:
#        - mountPath: "/home"
#          name: home
#      volumes:
#        - name: home
#          persistentVolumeClaim:
#            claimName: sharedhome
---
apiVersion: v1
kind: Service
metadata:
  name: $NAME
spec:
  type: ClusterIP
  selector:
    app: $NAME
  ports:
  - protocol: TCP
    port: 3389
    targetPort: 3389
EOF

# Wait for the port to come up
# (this really should be tied to the container being ready)
while ! nc -z -w 1 $NAME $PORT >> /tmp/$NAME 2>&1 ; do
  sleep 0.1
done

# Establish the stream
nc -k -q 60 -w 300 $NAME $PORT

# Clean up the spawned container
kubectl delete deployment/$NAME >> /tmp/$NAME 2>&1
kubectl delete service/$NAME >> /tmp/$NAME 2>&1
