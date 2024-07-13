#FROM nginxinc/nginx-unprivileged:1.25-alpine
FROM openresty/openresty:1.25.3.1-0-alpine-apk

MAINTAINER Jens Hassler <j.hassler@iwf.ch>

# Argument variables
ARG GIT_COMMIT
ARG GIT_BRANCH=releases/nginx-1.25-openresty
ARG GIT_DIRTY=undefined
ARG BUILD_CREATOR
ARG BUILD_NUMBER
ARG TIMEZONE=Europe/Zurich

ENV DEBIAN_FRONTEND=noninteractive

# default env variables for the clamav virus scanning connection
ENV SCAN_PATH="/vscan"
ENV CLAMAV_HOST="clamav"
ENV CLAMAV_PORT=9000

# This one defines which config file is linked into sites.d (APP_FRAMEWORK.conf)
ENV APP_FRAMEWORK="symfony4"
ENV RUNTIME_ENVIRONMENT="local"
ENV DOCUMENT_ROOT="/app/web"

# The host the script should "wait for" on startup by default - if empty, script does not wait
ENV WAIT_FOR="fpm:9000"
# The upstream host:port for nginx as proxy (nginx server directive)
ENV UPSTREAM_SERVER="fpm:9000"
# The setting of "access_log"
ENV ACCESS_LOG="off"
# The setting for "listen" - normally this should be 80, but the unprivileged image may have to listen on port 8080
ENV LISTEN_PORT="80"

# Add labels
LABEL io.web-solutions.git-branch=$GIT_BRANCH \
      io.web-solutions.git-commit=$GIT_COMMIT \
      io.web-solutions.git-is-dirty=$GIT_DIRTY \
      io.web-solutions.build-creator=$BUILD_CREATOR \
      io.web-solutions.build-number=$BUILD_NUMBER

# adjustments for openresty image to add non-privileged user
RUN apk add envsubst lua-resty-http && cp /usr/share/lua/common/resty/* /usr/local/openresty/lualib/resty/
RUN addgroup --gid ${GID:-101} nginx && adduser --uid ${UID:-101} -G nginx --disabled-password --gecos "" nginx
RUN mkdir /var/log/nginx && chown -R nginx /var/log/nginx
RUN chown -R nginx /var/run/openresty /usr/local/openresty/nginx

# COPY our config
COPY --chown=nginx ./assets/ /

# temporarily switch to root
USER root

# adjust ownerships
RUN chmod +x /usr/local/bin/webstartup.sh && chmod +x /usr/local/bin/wait-for.sh


# install additional software
# netcat (nc) for wait-for.sh script, openssl for initial local certs, sudo for the startup scripts
# this stuff will be removed upon startup in 99_cleanup.sh
RUN apk update && apk add --no-cache netcat-openbsd openssl sudo

# upgrade all software to newest versions
RUN apk add --upgrade --no-cache apk-tools && apk upgrade --no-cache --available

# Set time zone
RUN ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# pre-create the document root
RUN mkdir -p ${DOCUMENT_ROOT} && chown nginx ${DOCUMENT_ROOT}

# remove symlinks to busybox for some unneeded internet tools - the commands itself cannot be deleted.
RUN rm -f /bin/wget /usr/bin/wget /bin/ping /usr/bin/ping /bin/curl /usr/bin/curl

# enable sudo for making startup scripts work and switch back to unprivileged user
RUN echo "nginx ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER nginx

ENTRYPOINT ["/usr/local/bin/webstartup.sh"]
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;", "-c", "/data/conf/nginx/nginx.conf"]
