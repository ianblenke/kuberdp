all: build
	$(shell cat .env) ./apply-resources.sh
	sleep 5
	export $(shell cat .env) ; \
	kubectl port-forward $$(kubectl get pod --namespace $$KUBE_NAMESPACE | grep spawner | grep Running | awk '{print $$1}' | head -1) 3389:3389

build:
	export $(shell cat .env) ; \
	make -C $$DESKTOP_NAME
	make -C spawner

push: build
	export $$(cat .env) ; \
	make -C $$DESKTOP_NAME
	make -C spawner push
	
