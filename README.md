# IWF Nginx Docker Base Image

## Overview

This is a Docker base image for an Nginx webserver communicating with a PHP-FPM server running in a separate
container.

It's a vital part of the IWF application stack.

This image contains configurations for Symfony4/5 and CraftCMS.

It should be used together with our [PHP base image](https://hub.docker.com/repository/docker/iwfwebsolutions/phpfpm).

## Links

The image is built weekly based on the official image `openresty:1.25.x.x-alpine-apk`. 
This base image allows having complex rules applied e.g. by Lua in the webserver configuration. This is needed to allow pass-thru virus scanning with `clamav-rest`. 

It's available here: https://hub.docker.com/repository/docker/iwfwebsolutions/nginx

You should always use the tag: `iwfwebsolutions/nginx:1.25-latest`

## Versions

The X part of the version number `1.25-X` is always increased when we update the image configuration (e.g. config files).

It is NOT an indication to the patch level of the base image. It's **always** the **latest** nginx image of the supplied version,
currently only `1.25`.

See the CHANGELOG to find out the details.

## Changes to the official base image

| Change                          | Description                                                                                                                                                                                   |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| assets                          | all the files in the `build/assets` folder are copied to the base image root                                                                                                                  |
| framework specific config files | The config files in the folder `build/assets/data/conf/nginx/framework-configs` are linked into the folder `/data/conf/nginx/sites.d` on startup through the script `00_link_config_files.sh` |
| timezone                        | The timezone in the Linux environment is changed to the `TIMEZONE` environment variable (default: Europe/Zurich)                                                                              |
| document root                   | The document root specified in the `DOCUMENT_ROOT` environment variable is pre-created                                                                                                        |
| entrypoint                      | This is the script that runs when the image is started:`/usr/local/bin/webstartup.sh` - this starts all scripts in `dockerinit.d` folder                                                      |
| command                         | This starts the webserver:`nginx -g "daemon off;" -c "/data/conf/nginx/nginx.conf"`                                                                                                           |
| security headers                | Some security headers are automatically added - [described here](security-headers.md)                                                                                                         |

## Usage / Environment variables

At the moment this image can be configured with all the configurations in the folder: `build/assets/data/conf/nginx/framework-configs`

The configuration can be chosen with the environment variable `APP_FRAMEWORK`.

Currently you have the following options:

| Environment variable | default value | Description                                                                                                                                                                                                                            |
|----------------------|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| APP_FRAMEWORK        | symfony4      | The configuration file to link:`symfony` for Symfony 3 (app.php in `web`).`symfony4` for Symfony 4/5 (index.php in `public`).`craftcms` or `craftcms-nocache` for CraftCMS 3/4,                                                        |
| RUNTIME_ENVIRONMENT  | local         | Needed for scripts, currently only for `30_adjust_robots-txt.sh` (see below). Options:`<br>local`, `dev`, `qa`, `prod`                                                                                                                 |
| DOCUMENT_ROOT        | /app/web      | Directory where the webserver expects your static files to be mounted or copied into                                                                                                                                                   |
| WAIT_FOR             | fpm:9000      | The webserver waits for the FPM container to be started and answer network calls on Port 9000. Disable with an empty string.                                                                                                           |
| UPSTREAM_HOST        | fpm:9000      | The upstream host:port for nginx as proxy (nginx `server` directive)                                                                                                                                                                   |
| ACCESS_LOG           | off           | Enable the access log by specifying a path to the access log file (inside the container), you normally should use `/var/log/nginx/access.log`                                                                                          |
| ERROR_LOG            | stderr warn   | Enable the error log by specifying a path to the error log file (inside the container, e.g. `/var/log/nginx/error.log warn`), or `stderr LEVEL` for using streamed logging                                                             |
| LISTEN_PORT          | 80            | Change this to "8080" on the unprivileged image if the container cannot bind to port 80                                                                                                                                                |
| CLAMAV_SCAN_PATH     | /vscan        | Shared directory with the clamav service to exchange files for virus scanning                                                                                                                                                          |
| CLAMAV_HOST          | clamav        | The host (reachable from within nginx) in your docker stack via http running the image iwfwebsolutions/clamav-rest. This should be overwritten in a K8s cluster with the fully qualified name, e.g. clamav.NAMESPACE.svc.cluster.local |
| CLAMAV_SERVICE_PORT  | 9000          | The port of the clamav rest service.                                                                                                                                                                                                   |
| CLAMAV_FORWARD_ROUTE | /index.php    | The route the virus scanner should forward the original request if no virus is found                                                                                                                                                   |


## Default startup scripts

All the scripts in the container's `/data/dockerinit.d` folder are run on each startup:

| Script                        | Description                                                                                                                                                                             |
|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 00_create_self-signed-cert.sh | Creates a self-signed certificate for the webserver if no certificate exists in /data/conf/nginx/certificates                                                                           |
| 00_enable_site.sh             | Copies and resolves `UPSTREAM_SERVER` with the `APP_FRAMEWORK`.conf file from `nginx/framework-configs` to `nginx/sites.d` where it's picked up by the default `nginx.conf`             |
| 00_wait-for-deps.sh           | Waits for the `WAIT_FOR` server -- by default for the PHP FPM server                                                                                                                    |
| 30_adjust_robots-txt.sh       | Creates a "Disallow all" robots.txt file for all environments (defined by `RUNTIME_ENVIRONMENT`) NOT being `local` and `prod`. This prevents search engines to index your DEV/QA sites. |
| 99_cleanup.sh                 | Removes some system software that is only required for the startup process                                                                                                              |

## Extension points (change or extend configuration)

You can insert your own configuration at these points. Just mount your own config files into these directories or create a derived image from this one
and change the files as needed.

| Folder                              | Description                                                                                                                                  |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| /data/conf/nginx/http-partials.d    | `.conf` files here are included by the framework configs at the http (global) level                                                          |
| /data/conf/nginx/server-partials.d  | `.conf` files here are included by the framework configs at the server level                                                                 |
| /data/conf/nginx/security-headers.d | `.conf` files here are included by the server and location configs to extend or override the applied [security headers](security-headers.md) |
| /data/conf/nginx/main.d             | `.conf` files here are included in the main section of nginx, e.g. to define `env` statements |                                               |
| /data/conf/nginx/certificates       | You should mount this directory to a folder on your host system. See the SSL section for further details.                                    |

## Unprivileged image

This is an **unprivileged** image running as user "nginx" (uid 101).

All the things you do atop this base image must respect this. If you copy additional files with the COPY directive,
you have to use it like this: "COPY --chown=nginx ..."

The unprivileged image may not be able to bind to port 80 if the runtime engine does not allow it (e.g. podman by default).
In this case, you can set LISTEN_PORT env var to 8080 and change the port mapping to the outside from '80:80' to '80:8080'.

## Virus scanning with clamav-rest

### include the clamav-rest container in your docker stack

This is the minimum config. Please see the docs of clamav-rest, especially for configuration values.

The max size parameters should match the maximum allowed upload size in your application.

```
  clamav:
    image: iwfwebsolutions/clamav-rest:latest
    environment:
      MAX_SCAN_SIZE: 100M # default 100M
      MAX_FILE_SIZE: 100M # default 25M
    volumes:
      - ./data/vscan:/vscan
```

### setup the shared virus scanning directory

To allow fast virus scanning, the uploaded files must be stored temporarily in a folder accessible by nginx and clamav-rest.
The default folder name inside the container is `/vscan`, but that can be changed with the `SCAN_PATH` environment variable (see above).

The folder must exist in the mounted filesystem path, and both the `nginx` and `clamav` services must be configured the same way and have access to the same folder.

The user with id `101` (nginx) should have write access.

### application specific configuration

To enable on-upload virus scanning you have to put a file with location blocks of your upload routes to the `server-partials.d` directory.
Include the file `clamav-scan.conf` there. Each location you put there is routed through the virus scanning service.

To make it work, each route should comply with the following rules:

- accept POST requests. Requests with other HTTP methods are forwarded as is.
- accepts files as multipart form binary

All files in a multipart form are checked for malware, but the scanner returns early - as soon as the first malware was found.

See the documentation of `iwfwebsolutions/clamav-rest` for the returned status codes. 
Generally, if no virus is found, it returns 200 and forwards the request to the CLAMAV_FORWARD_ROUTE (`/index.php` by default).
If a virus is found, it returns a status code 406 to the frontend and a json body containing the name of the found malware.

Example `server-partials.d/upload.conf`:

```
location "/common/api/files" {
    include "clamav-scan.conf";
}
```

To include a basic rate limiting use the following config:

```
location "/common/api/files" {
    limit_req zone=vscan-scan burst=5;
    include "clamav-scan.conf";
}
```

There are 2 basic rate limiters configured in the `nginx.conf`. 

- `vscan-scan`: 30 requests/minute per IP address
- `vscan-health`: 10 requests/minute per IP address

By using these, the requests are delayed until a new slot is free.


If you have special use cases where you don't want to forward the request to CLAMAV_FORWARD_ROUTE you can forward
the original non-virus request to a named location by doing this:

```
location @my_forward_route {
  // do something here
}

location "/common/api/files" {
   set $clamav_foward_route @my_forward_route;
   include "clamav-scan.conf";
}
```

If the variable `$clamav_forward_route` is set it will use this one, otherwise it uses the env var CLAMAV_FORWARD_ROUTE.

### enable the virus scanning healthcheck endpoint

By configuring this endpoint you can monitor if the virus signatures are up2date and the scanner is reachable and running:

```
location "/vscan-healthcheck" {
    limit_req zone=vscan-health burst=1;
    include "clamav-health.conf";
}
```

This endpoint returns `200` if everything's fine, `420` if the signatures are out-of-date, and a 500er if something else is wrong (e.g. scanner not running).
See the docs of `iwfwebsolutions/clamav-rest` for more details.


## SSL support

You can store your own SSL certificates in the folder `/data/conf/nginx/certificates`. The files should be named `cert.pem` and `key.pem`.
If you don't supply your own files, this image will automatically generate a self signed SSL certificate inside this folder.
The diffie hellman parameter file (`dhparam.pem`) will be also created and stored in this folder if it doesn't exist.

## Framework specific

### Symfony 4, 5, 6

### Craft CMS

The nginx config file (`docker/build/assets/data/conf/nginx/framework-configs/craftcms-blitz.conf`) is used for Blitz Cache Plugin configuration.
Cached files are located in `/app/web/cache` directory.

## Contribute!

Contribute to this project and all the other's by creating issues & pull requests.

Thanks for your help!

## Get help

Use the [issue system on Github](https://github.com/iwf-web/docker-nginx) to report errors or suggestions.

You can also write to opensource@iwf.io. We try to answer every question, but it might take some days.
