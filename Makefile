## include .env
ifneq (,$(wildcard ./.env))
	include .env
	export
endif

DOCKER_COMPOSE = 	DOCKER_HUB_REPO=$(DOCKER_HUB_REPO) \
				 	BUILD_ID=$(shell date +%s) \
					docker-compose -f docker/docker-compose.yml 

## App commands
run:
	@UIDGID=$(shell id -u):$(shell id -g) $(DOCKER_COMPOSE) run app whoami
.PHONEY: run

debug:
	@UIDGID=$(shell id -u):$(shell id -g) $(DOCKER_COMPOSE) run -it app /bin/bash
.PHONEY: debug

debug_root:
	@$(DOCKER_COMPOSE) run -it app /bin/bash
.PHONEY: debug_root

## Build Agent Commands
# build
build:
	@echo "$(ANSIBLE_VAULT_PASS)" > docker/ansible_vault_password
	@cd docker && docker build \
					--build-arg UID=$(shell id -u) \
					--build-arg GID=$(shell id -g) \
					--build-arg USERNAME=$(shell id -un) \
					--build-arg GROUPNAME=$(shell id -gn) \
					-t $(DOCKER_HUB_REPO):latest .
	@rm docker/ansible_vault_password
.PHONEY: build

# rebuild
rebuild: clean build push
.PHONEY: rebuild

# clean
clean:
	@cd docker && docker rmi $(DOCKER_HUB_REPO):latest &>/dev/null || true
.PHONEY: clean

# push
push:
	@docker login && docker push $(DOCKER_HUB_REPO):latest
.PHONEY: push

# pull
pull:
	@docker pull $(DOCKER_HUB_REPO):latest
.PHONEY: pull
