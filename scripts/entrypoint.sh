#!/bin/bash

export WEBMIN_PASS="${WEBMIN_PASS:-admin}"
export USE_SSL="${USE_SSL:-true}"
export BASE_URL="${BASE_URL:-localhost}"

export SD_USER="${SD_USER:-admin}"
export SD_PASS="${SD_PASS:-admin}"




if [ "${USE_SSL,,}" = true ] && [ -n "${BASE_URL+x}" ]; then
    echo "Generating SSL certificate"
    sed -i 's/ssl=/ssl=1/g' /etc/webmin/miniserv.conf
    tempdir=/tmp/certs
    mkdir $tempdir
    openssl req -newkey rsa:2048 -x509 -nodes -out $tempdir/cert -keyout $tempdir/key -days 1825 -sha256 -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=${BASE_URL}" || exit 1
    cat $tempdir/cert $tempdir/key > /etc/webmin/miniserv.pem
    rm -rf $tempdir
fi

#export DISABLED_MODULES=(fail2ban)

#for i in ${DISABLED_MODULES} do
#    sed -e 's/"${i}"//' -i /etc/webmin/webmin.acl
#do

echo "admin: samba" >  /etc/webmin/webmin.acl



#kfile=$config_dir/miniserv.pem
#openssl req -newkey rsa:2048 -x509 -nodes -out $tempdir/cert -keyout $tempdir/key -days 1825 -sha256 >/dev/null 2>&1 
#cat $tempdir/cert $tempdir/key >$kfile

#sed -i 's/logfile=\/var\/webmin\/miniserv.log/logfile=\/dev\/stdout/g' /etc/webmin/miniserv.conf
#sed -i 's/errorlog=\/var\/webmin\/miniserv.error/errorlog=\/dev\/stderr/g' /etc/webmin/miniserv.conf

if [ ! "${WEBMIN_PASS}" = "admin" ];then
    echo "Changing password for admin"
    /opt/webmin/changepass.pl /etc/webmin admin ${WEBMIN_PASS}
#echo root:${WEBMIN_PASS} | chpasswd
fi

exec "$@"
