IMAGE_NAME ?= jira_metrics
TARGET_IMAGE_NAME ?= jira_metrics
CURRENT_DIR = $(shell pwd)

.PHONY: run
run:	
	docker run --rm -p 8080:80 -it -v "${CURRENT_DIR}/config":/config -v "${CURRENT_DIR}"/output:/data -e JIRA_USER="${JIRA_USER}" -e JIRA_PASS="${JIRA_PASS}" ${IMAGE_NAME}:latest

.PHONY: run-debug
run-debug:	
	docker run --name metrics_server --rm -i -t ${IMAGE_NAME}:latest bash
	
.PHONY: install
install:
	pip3 install --no-cache-dir ./

.PHONY: image
image:
	docker build . -f Dockerfile.webapp -t ${IMAGE_NAME}

.PHONY: push
push:
	docker tag ${IMAGE_NAME} quay.io/hbraun/${TARGET_IMAGE_NAME}
	docker push quay.io/hbraun/${TARGET_IMAGE_NAME}