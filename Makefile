KUBE_NAMESPACE=default

all: build
	KUBE_NAMESPACE=${KUBE_NAMESPACE} ./apply-resources.sh
	sleep 5
	kubectl port-forward $$(kubectl get pod --namespace ${KUBE_NAMESPACE} | grep spawner | grep Running | awk '{print $$1}' | head -1) 3389:3389

build:
	make -C desktop
	make -C spawner

push: build
	make -C desktop push
	make -C spawner push
	
