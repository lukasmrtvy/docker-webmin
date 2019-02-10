#!/bin/bash

export WEBMIN_PASSWORD="${WEBMIN_PASSWORD:-admin}"
export USE_SSL="${USE_SSL:-true}"
export BASE_URL="${BASE_URL:-localhost}"
export ALLOW_ONLY_SAMBA_RELATED_MODULES="${ALLOW_ONLY_SAMBA_RELATED_MODULES:-true}"

if [ "${USE_SSL,,}" = true ] && [ -n "${BASE_URL+x}" ]; then
    sed -i 's/ssl=/ssl=1/g' /etc/webmin/miniserv.conf
    if [ ! -f /etc/webmin/miniserv.pem ]; then
        echo "Generating SSL certificate"
        tempdir=/tmp/certs
        mkdir -p $tempdir
        openssl req -newkey rsa:2048 -x509 -nodes -out $tempdir/cert -keyout $tempdir/key -days 1825 -sha256 -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=${BASE_URL}" || exit 1
        cat $tempdir/cert $tempdir/key > /etc/webmin/miniserv.pem
        rm -rf $tempdir
    fi
fi

if [ "${ALLOW_ONLY_SAMBA_RELATED_MODULES,,}" = true ]; then
    echo "admin: samba system-status backup-config changeuser webminlog webmin acl mount" >  /etc/webmin/webmin.acl
fi

if [ ! "${WEBMIN_PASSWORD}" = "admin" ];then
    echo "Changing password for admin"
    /opt/webmin/changepass.pl /etc/webmin admin ${WEBMIN_PASS}
fi

exec "$@"
