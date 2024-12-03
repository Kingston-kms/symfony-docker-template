include .env
PHP_IMAGE_NAME=project:symfony-php-8-2-alpine
_IMAGE_ID = $(shell docker image ls $(PHP_IMAGE_NAME) -q)

docker_env=
ifeq ($(APP_ENV), prod)
docker_env=-f docker-compose.prod.yml
endif

docker_command=docker compose -f docker-compose.yml $(docker_env)

default: help

help:
	@echo ' Скрипт управления контейнерами проекта на symfony с базой данных'
	@echo ' Сборка базового образа php и сборка контейнеров docker compose'
	@echo ' Остановка, удаление и чистка файлов'
	@echo ''
	@echo '	make build-common - сборка базового образа'
	@echo '	make build - сборка контейнеров проекта'
	@echo '	make up - запуск контейнеров'
	@echo '	make down - остановка контейнеров'
	@echo '	make clean - очистка контейнеров'
	@echo '	make cli - консоль php проекта'

check-common-image:
	$(if $(_IMAGE_ID),$(info Good. Exist image $(_IMAGE_ID)),$(error Need to build image by command: make build-common))

build-common:
	docker build --no-cache -t $(PHP_IMAGE_NAME) -f .docker/php/Dockerfile.common .

build:
	$(docker_command) build --no-cache

up:
	$(docker_command) up -d

down:
	$(docker_command) down

clean:
	$(docker_command) down --rmi local

cli:
	$(docker_command) run --rm php-cli sh