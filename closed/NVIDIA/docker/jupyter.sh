#!/usr/bin/env bash
set -eu

jupyter lab --ip=0.0.0.0 --port=8082 --no-browser --allow-root \
  --LabApp.token='' \
  --LabApp.custom_display_url=${JOB_URL_SCHEME}${JOB_ID}-8082.${JOB_HOST} \
  --LabApp.allow_remote_access=True \
  --LabApp.allow_origin='*' \
  --LabApp.disable_check_xsrf=True