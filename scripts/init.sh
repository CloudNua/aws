#!/bin/sh -e
set -x

terraform init -reconfigure -upgrade \
    -backend-config="address=https://gitlab.com/api/v4/projects/26032079/terraform/state/production" \
    -backend-config="lock_address=https://gitlab.com/api/v4/projects/26032079/terraform/state/production/lock" \
    -backend-config="unlock_address=https://gitlab.com/api/v4/projects/26032079/terraform/state/production/lock" \
    -backend-config="username=endk17" \
    -backend-config="password=$GIT_TOKEN" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"