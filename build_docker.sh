#!/bin/sh -ex

# docker system prune -a

tar cz Dockerfile souper | docker build -t artifact-cgo -
#container=$(/usr/bin/docker run -d souperweb true)
#docker export $container | docker import - souperweb_squashed

#docker build -t souperweb_final - < Dockerfile.metadata
#docker tag souperweb_final liuz/souperweb

# docker push regehr/souperweb
