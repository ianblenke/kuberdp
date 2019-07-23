all:
	docker-compose build

up:
	# Foreground
	docker-compose up --force-recreate
	# Background
	#docker-compose up -d --force-recreate

push:
	export $$(cat .env) ;\
	docker push $$DESKTOP_IMAGE
