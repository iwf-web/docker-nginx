# Changelog

`1.27-1` (2024-11-22)
- new stream for newest openresty base image based on nginx 1.27

`1.25-vscan-8` (2024-11-22)
- vscan: improve logging and allow forwarding to named locations

  `1.25-vscan-7` (2024-11-14)
- vscan: better handling of many files in a multipart request 

`1.25-vscan-6` (2024-11-12)
- vscan: allow all methods for virus scanning endpoints - clamav will only handle PUT & POST requests

`1.25-vscan-5` (2024-11-12)
- vscan: rename CLAMAV_PORT to CLAMAV_SERVICE_PORT as K8s automatically creates env variables overriding our default 

`1.25-vscan-4` (2024-09-10)
- fix cleanup script to not download package index on startup

`1.25-vscan-3` (2024-09-06)
- add extension point for main config

`1.25-vscan-2` (2024-08-06)
- add healthcheck configuration
- add basic rate limiting for virus scanning

`1.25-vscan-1` (2024-07-24)
- add virus scanning feature
- move to OpenResty as base nginx image
- change default error logging to stderr
- add environment variables for adjusting the logging

`1.24-unprivileged-5` (2024-01-12)
- remove apk after startup & remove symlinks to some net tools 

`1.24-unprivileged-4` (2023-12-20)
- enable multi platform builds

`1.24-unprivileged-3` (2023-11-13)
- make the "listen" port configurable (default 80 - again)

`1.24-unprivileged-2` (2023-11-10)
- image listens now on port 8080 because podman can't bind to port 80

`1.24-unprivileged-1` (2023-11-03)
- add unprivileged image variant based on nginxinc/nginx-unprivileged
- remove unneeded system packages after startup
- unified logging into /var/log/nginx/error.log
- configurable access_log

`1.24-1` (2023-06-05)
- update to new stable version 1.24

`1.22-7` (2023-02-20)
- README update

`1.22-6` (2022-12-23)
- add ssl to craftcms-blitz.conf

`1.22-5` (2022-12-23)
- add new craftcms-blitz.conf

`1.22-4` (2022-12-23)
- updated some parameters in ssl.conf

`1.22-3` (2022-12-13)
- use -dsaparam option to speedup dhparam.pem generation

`1.22-2` (2022-12-13)
- add SSL support

`1.22-1` (2022-11-24)
- new nginx version 1.22

`1.20-5` (2022-08-18)
- larger fast_cgi_buffer_size 

`1.20-4` (2022-06-28)
- change header X-Frame-Options to SAMEORIGIN

`1.20-3` (2022-06-13)
- special craftcms config for backend

`1.20-2` (2022-06-07)
- default security headers

`1.20-1` (2022-02-28)
- new nginx version

`1.14-22` (2020-12-04)
- add new variable UPSTREAM_HOST
- replace startup routine to copy and substitute UPSTREAM_HOST variable
- add variable UPSTREAM_HOST to all framework config files

`1.14-21` (2020-08-19)
- add try_files for robots.txt location (craftcms only)

`1.14-20` (2020-06-25)
- populate real scheme for craftcms

`1.14-18` (2020-03-06)
- add 'craftcms-simplecache' configuration

`1.14-16`, `1.14.17` (2019-12-19)
- fixes to symfony config

`1.14-15` (2019-12-17)
- Fix build script

`1.14-14` (2019-11-15)
- Fix Symfony4 config

`1.14-13` (2019-11-15)
- add Symfony4 config

`1.14-12` (2019-10-07)
- craftms config: updated cache settings for background and locking

...
