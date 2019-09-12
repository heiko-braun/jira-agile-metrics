IMAGE_NAME ?= metrics-server
CURRENT_DIR = $(shell pwd)

.PHONY: run
run:	
	docker run --rm -p 8080:80 -it -v "${CURRENT_DIR}/config":/config -v "${CURRENT_DIR}"/output:/data -e JIRA_USER="${JIRA_USER}" -e JIRA_PASS="${JIRA_PASS}" ${IMAGE_NAME}:latest

.PHONY: install
install:
	pip3 install --no-cache-dir ./

.PHONY: image
image:
	docker build . -f Dockerfile.webapp -t ${IMAGE_NAME}