all: build
	./apply-resources.sh
	kubectl port-forward $$(kubectl get pod | grep spawner | grep Running | awk '{print $$1}' | head -1) 3389:3389

build:
	make -C desktop
	make -C spawner

push: build
	make -C desktop push
	make -C spawner push
	
