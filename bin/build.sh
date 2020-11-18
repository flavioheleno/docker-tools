#!/bin/bash

set -eo pipefail

# SETTINGS
##########
APP_ENV=dev
APP_GROUP=1000
APP_USER=1000
PHP_VER=7.4.12

# IMAGE
#######
IMAGENAME=myapp
NAMESPACE=flavioheleno
TAG=$(date +%F)

# BUILD
#######
cd $(dirname $0)

DOCKER_BUILDKIT=1 docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_GROUP="${APP_GROUP}" \
  --build-arg APP_USER="${APP_USER}" \
  --build-arg PHP_VER="${PHP_VER}" \
  --compress \
  --file ../docker/Dockerfile \
  --no-cache=true \
  --pull=false \
  --ssh default="${SSH_AUTH_SOCK}" \
  --tag "${NAMESPACE}/${IMAGENAME}:${TAG}" \
  --target backend \
  ../

docker tag "${NAMESPACE}/${IMAGENAME}:${TAG}" "${NAMESPACE}/${IMAGENAME}:latest"
