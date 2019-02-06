#!/bin/bash

export WEBMIN_PASS="${WEBMIN_PASS:-admin}"
export USE_SSL="${USE_SSL:-true}"
export BASE_URL="${BASE_URL:-localhost}"
export DISABLE_OTHER_MODULES="${DISABLE_OTHER_MODULES:-true}"

if [ "${USE_SSL,,}" = true ] && [ -n "${BASE_URL+x}" ]; then
    echo "Generating SSL certificate"
    sed -i 's/ssl=/ssl=1/g' /etc/webmin/miniserv.conf
    tempdir=/tmp/certs
    mkdir $tempdir
    openssl req -newkey rsa:2048 -x509 -nodes -out $tempdir/cert -keyout $tempdir/key -days 1825 -sha256 -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=${BASE_URL}" || exit 1
    cat $tempdir/cert $tempdir/key > /etc/webmin/miniserv.pem
    rm -rf $tempdir
fi

if [ "${DISABLE_OTHER_MODULES,,}" = true ]; then
    echo "admin: samba system-status backup-config changeuser webminlog webmin acl mount" >  /etc/webmin/webmin.acl
fi

if [ ! "${WEBMIN_PASS}" = "admin" ];then
    echo "Changing password for admin"
    /opt/webmin/changepass.pl /etc/webmin admin ${WEBMIN_PASS}
fi

exec "$@"
