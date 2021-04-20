#!/bin/sh -e
set -x

terraform init -reconfigure -upgrade \
    -backend-config="address=https://gitlab.com/api/v4/projects/<YOUR-PROJECT-ID>/terraform/state/<YOUR-STATE-NAME>" \
    -backend-config="lock_address=https://gitlab.com/api/v4/projects/<YOUR-PROJECT-ID>/terraform/state/<YOUR-STATE-NAME>/lock" \
    -backend-config="unlock_address=https://gitlab.com/api/v4/projects/<YOUR-PROJECT-ID>/terraform/state/<YOUR-STATE-NAME>/lock" \
    -backend-config="username=<YOUR-USERNAME>" \
    -backend-config="password=<YOUR-ACCESS-TOKEN>" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"