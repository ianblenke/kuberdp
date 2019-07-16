KUBE_CONFIG_BASE64=$(shell kubectl config view --flatten --minify=true | openssl base64 -A)

all:
	KUBE_CONFIG_BASE64=${KUBE_CONFIG_BASE64} docker-compose build

up:
	KUBE_CONFIG_BASE64=${KUBE_CONFIG_BASE64} docker-compose up --force-recreate

push:
	export $$(cat .env); \
	docker push $$SPAWNER_IMAGE

