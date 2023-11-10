# Changelog

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
