#!/bin/bash

set -eo pipefail

cd $(dirname $0)
docker run --rm --env-file ../.env flavioheleno/myapp:latest "$@"
