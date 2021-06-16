#!/bin/bash
target=$1
set -x
apt-get update
apt-get install haproxy ca-certificates -y
touch haproxy.cfg
cat << EOF > haproxy.cfg
global
        log stdout format raw daemon debug

defaults
        log     global
        mode    tcp
        option  tcplog
        option  dontlognull
        timeout client 500s
        timeout connect 500s
        timeout server 500s

frontend site
   bind *:80
   mode tcp
   option tcplog
   default_backend site

backend site
server site-redirect-nonssl $target:80


frontend site_ssl
   bind *:443
   mode tcp
   option tcplog
   default_backend site_ssl

backend site_ssl
server site-redirect-ssl $target:443
EOF
haproxy -f haproxy.cfg
