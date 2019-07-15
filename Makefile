all:
	make -C desktop
	make -C spawner
	./apply-resources.sh

push:
	make -C desktop push
	make -C spawner push
	
