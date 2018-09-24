#!/bin/bash

echo "entrypoint"

export WEBMIN_USER="${WEBMIN_USER:-admin}"
export WEBMIN_PASS="${WEBMIN_PASS:-admin}"
export USE_SSL="${USE_SSL:-y}"

/usr/bin/expect /config.exp

exec "$@"
