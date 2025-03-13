#!/bin/bash
# ############################################################
# secrets2env.sh
#
# Set environment variables from secret files
#
# Based on https://stackoverflow.com/questions/48094850/docker-stack-setting-environment-variable-from-secrets#67830876
# with some adjustments, mainly with respect to how secrets are
# named. More info on how secrets work with Docker Compose:
# https://docs.docker.com/compose/how-tos/use-secrets/
# ############################################################

for secret_file in $(find /run/secrets -name '*' -type 'f'); do
    export "$(basename "${secret_file}")"="$(cat "$secret_file")"
done

# Chain with existing entrypoint (if any)
exec "$@"
