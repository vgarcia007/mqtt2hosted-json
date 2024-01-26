.PHONY: mqtt-script docker-pull

build: mqtt-script

docker-pull:
	docker pull ubuntu:20.04

mqtt-script: docker-pull
	docker build --no-cache -t mqtt-script -f Dockerfile .