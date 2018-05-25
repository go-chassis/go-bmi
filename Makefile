SHELL := /bin/bash
STATIC_FLAGS = '-w -extldflags "-static"'

DOCKERBIN = $(shell which docker)

GOBIN=$(shell which go)
GOBUILD=$(GOBIN) build

.PHONY: calculator webapp

all: k8s.calculator k8s.webapp

docker: docker.webapp docker.calculator

bin: webapp calculator


webapp:
	cd ./web-app; $(GOBUILD) -ldflags $(STATIC_FLAGS)

docker.webapp: webapp
	mv ./web-app/web-app ./k8s/
	cd ./k8s; $(DOCKERBIN) build -t bmi/webapp:v1 -f ./Dockerfile.webapp .

k8s.webapp: docker.webapp
	distribute-image.sh bmi/webapp:v1
	-kubectl delete -f ./k8s/webapp.yaml
	kubectl apply -f ./k8s/webapp.yaml

calculator:
	cd ./calculator; $(GOBUILD) -ldflags $(STATIC_FLAGS)

docker.calculator: calculator
	mv ./calculator/calculator ./k8s/
	cd ./k8s; $(DOCKERBIN) build -t bmi/calculator:v1 -f ./Dockerfile.calculator .

k8s.calculator: docker.calculator
	distribute-image.sh bmi/calculator:v1
	-kubectl delete -f ./k8s/calculator.yaml
	kubectl apply -f ./k8s/calculator.yaml


docker.servicecenter:
	cd ./k8s; $(DOCKERBIN) build -t bmi/servicecenter:v1 -f ./Dockerfile.servicecenter .

k8s.servicecenter: docker.servicecenter
	distribute-image.sh bmi/servicecenter:v1
	-kubectl delete -f ./k8s/servicecenter.yaml
	kubectl apply -f ./k8s/servicecenter.yaml
