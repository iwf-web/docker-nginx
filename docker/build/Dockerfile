FROM nginx:1.24-alpine

MAINTAINER Jens Hassler <j.hassler@iwf.ch>

# Argument variables
ARG GIT_COMMIT
ARG GIT_BRANCH=releases/nginx-1.24
ARG GIT_DIRTY=undefined
ARG BUILD_CREATOR
ARG BUILD_NUMBER
ARG TIMEZONE=Europe/Zurich

ENV DEBIAN_FRONTEND=noninteractive

# This one defines which config file is linked into sites.d (APP_FRAMEWORK.conf)
ENV APP_FRAMEWORK="symfony"
ENV RUNTIME_ENVIRONMENT="local"
ENV DOCUMENT_ROOT="/app/web"

# The host the script should "wait for" on startup by default - if empty, script does not wait
ENV WAIT_FOR="fpm:9000"
# The upstream host:port for nginx as proxy (nginx server directive)
ENV UPSTREAM_SERVER="fpm:9000"

# Add labels
LABEL io.web-solutions.git-branch=$GIT_BRANCH \
      io.web-solutions.git-commit=$GIT_COMMIT \
      io.web-solutions.git-is-dirty=$GIT_DIRTY \
      io.web-solutions.build-creator=$BUILD_CREATOR \
      io.web-solutions.build-number=$BUILD_NUMBER

# install additional software
# netcat (nc) for wait-for.sh script
RUN apk add --update --no-cache netcat-openbsd

# COPY our config
COPY ./assets/ /
RUN chmod +x /usr/local/bin/webstartup.sh
RUN chmod +x /usr/local/bin/wait-for.sh

# Set time zone
RUN ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# pre-create the document root
RUN mkdir -p ${DOCUMENT_ROOT}

ENTRYPOINT ["/usr/local/bin/webstartup.sh"]
CMD ["nginx", "-g", "daemon off;", "-c", "/data/conf/nginx/nginx.conf"]
