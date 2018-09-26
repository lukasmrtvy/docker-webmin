#!/bin/bash

export WEBMIN_PASS="${WEBMIN_PASS:-admin}"
export DISABLE_SSL="${DISABLE_SSL:-false}"

export SD_USER="${SD_USER:-admin}"
export SD_PASS="${SD_PASS:-admin}"

export 


if [ "${USE_SSL,,}" = true ]; then
    echo "Disabling SSL"
    sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
fi

#sed -i 's/logfile=\/var\/webmin\/miniserv.log/logfile=\/dev\/stdout/g' /etc/webmin/miniserv.conf
#sed -i 's/errorlog=\/var\/webmin\/miniserv.error/errorlog=\/dev\/stderr/g' /etc/webmin/miniserv.conf


/opt/webmin/changepass.pl /etc/webmin admin ${WEBMIN_PASS}
#echo root:${WEBMIN_PASS} | chpasswd

exec "$@"
