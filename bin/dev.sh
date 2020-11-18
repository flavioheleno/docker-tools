#!/bin/bash

set -eo pipefail

cd $(dirname $0)

CID=$(docker ps -q -f status=running -f name=^/myappdev$)
if [ ! "${CID}" ]; then
  docker run --rm -ti --env-file ../.env -v $(pwd)/../src:/usr/src/app --name myappdev flavioheleno/myapp:latest bash
else
  docker exec -ti myappdev bash
fi
