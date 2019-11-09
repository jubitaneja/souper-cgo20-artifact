#!/bin/sh -ex

# docker system prune -a

tar cz Dockerfile precision/souper performance/souper | docker build -t artifact-cgo -
#container=$(/usr/bin/docker run -d souperweb true)
#docker export $container | docker import - souperweb_squashed

#docker build -t souperweb_final - < Dockerfile.metadata
docker tag artifact-cgo jubitaneja/artifact-cgo

# docker push jubitaneja/artifact-cgo
