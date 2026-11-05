#!/bin/sh

# create a self signed cert if no cert exists in path /data/conf/nginx/certificates/cert.pem
if [ ! -f '/data/conf/nginx/certificates/cert.pem' ]; then
  openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -keyout /data/conf/nginx/certificates/key.pem -out /data/conf/nginx/certificates/cert.pem -config /data/conf/nginx/ssl/self-signed-cert.conf
fi
if [ ! -f '/data/conf/nginx/certificates/dhparam.pem' ]; then
  openssl dhparam -dsaparam -out /data/conf/nginx/certificates/dhparam.pem 2048
fi
