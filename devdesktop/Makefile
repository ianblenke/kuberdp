all:
	docker-compose build

up:
	docker-compose up --force-recreate

push:
	export $$(cat .env) ;\
	docker push $$DESKTOP_IMAGE
