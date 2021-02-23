#!/usr/bin/env bash

export JUPYTER_JOB_URL=${JOB_URL_SCHEME}${JOB_ID}-8082.${JOB_HOST}
export CODE_JOB_URL=${JOB_URL_SCHEME}${JOB_ID}-8081.${JOB_HOST}
envsubst < /usr/bin/home-server.html > /usr/opt/index.html
python3 -m http.server 8080