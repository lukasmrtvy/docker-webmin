FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl tar perl libnet-ssleay-perl libauthen-pam-perl expect tzdata supervisor samba && \
    mkdir /opt/webmin && curl -sSL https://prdownloads.sourceforge.net/webadmin/webmin-1.900.tar.gz | tar xz -C /opt/webmin --strip-components=1 && \
    mkdir -p /var/webmin/ && \
    ln -s /dev/stdout /var/webmin/miniserv.log && \
    ln -s /dev/stderr /var/webmin/miniserv.error

COPY /scripts/entrypoint.sh /
COPY /scripts/supervisord.conf /

RUN chmod +x entrypoint.sh

ENV nostart=true
ENV nouninstall=true
ENV noportcheck=true
ENV ssl=0
ENV login=admin
ENV password=admin
ENV atboot=false

RUN  /opt/webmin/setup.sh

VOLUME /etc/webmin/
VOLUME /etc/samba/
VOLUME /var/lib/samba/

EXPOSE 10000

EXPOSE 137/udp
EXPOSE 138/udp
EXPOSE 139
EXPOSE 445

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]
