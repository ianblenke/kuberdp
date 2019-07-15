KUBE_CONFIG_BASE64=$(shell kubectl config view --flatten --minify=true | openssl base64 -A)
DOCKER_CONFIG_JSON=$(shell jq -c . ~/.docker/config.json)

all:
	DOCKER_CONFIG_JSON=${DOCKER_CONFIG_JSON} KUBE_CONFIG_BASE64=${KUBE_CONFIG_BASE64} docker-compose build

up:
	DOCKER_CONFIG_JSON=${DOCKER_CONFIG_JSON} KUBE_CONFIG_BASE64=${KUBE_CONFIG_BASE64} docker-compose up --force-recreate

push:
	export $$(cat .env); \
	docker push $$SPAWNER_IMAGE

