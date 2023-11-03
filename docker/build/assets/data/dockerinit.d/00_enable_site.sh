#!/usr/bin/env sh
set -eu

echo -n "  Enabling site with '${APP_FRAMEWORK}' framework and upstream '${UPSTREAM_SERVER}'..."
envsubst '${UPSTREAM_SERVER}' < /data/conf/nginx/framework-configs/${APP_FRAMEWORK}.conf > /data/conf/nginx/sites.d/${APP_FRAMEWORK}.conf
envsubst '${ACCESS_LOG}' < /data/conf/nginx/nginx.conf > /data/conf/nginx/nginx.conf.tmp && mv /data/conf/nginx/nginx.conf.tmp /data/conf/nginx/nginx.conf
echo " done."
