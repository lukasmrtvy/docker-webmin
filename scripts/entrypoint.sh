#!/bin/bash

export WEBMIN_PASS="${WEBMIN_PASS:-admin}"
export DISABLE_SSL="${DISABLE_SSL:-false}"


if [ "${USE_SSL,,}" = true ]; then
    sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
fi


echo root:${WEBMIN_PASS} | chpasswd

exec "$@"
