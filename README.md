# IWF Nginx Docker Base Image

## Overview

This is a Docker base image for an Nginx webserver communicating with a PHP-FPM server running in a separate
container.

It's a vital part of the IWF application stack.

This image contains configurations for Symfony3, Symfony4 and CraftCMS.

It should be used together with our [PHP base image](https://hub.docker.com/repository/docker/iwfwebsolutions/phpfpm).


## Links

The image is built weekly based on the official image `nginx:1.22-alpine`.

It's available here: https://hub.docker.com/repository/docker/iwfwebsolutions/nginx

You should always use the tag: `iwfwebsolutions/nginx:1.22-latest`

## Versions

The X part of the version number `1.22-X` is always increased when we update the image configuration (e.g. config files).

It is NOT an indication to the patch level of the base image. It's **always** the **latest** nginx image of the supplied version,
currently only `1.22`.

See the CHANGELOG to find out the details.

## Changes to the official base image

| Change                          | Description                                                                                                                                                                                   |
| ------------------------------- |-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
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

Currently you have 3 options:

| Environment variable | default value | Description                                                                                                                                                                                           |
| -------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| APP_FRAMEWORK        | symfony       | The configuration file to link:`<br>symfony` for Symfony 3 (app.php in `web`).`<br>symfony4` for Symfony 4 (index.php in `public`).`<br>craftcms` or `craftcms-nocache` for CraftCMS 3/4, |
| RUNTIME_ENVIRONMENT  | local         | Needed for scripts, currently only for `30_adjust_robots-txt.sh` (see below). Options:`<br>local`, `dev`, `qa`, `prod`                                                                      |
| DOCUMENT_ROOT        | /app/web      | Directory where the webserver expects your static files to be mounted or copied into                                                                                                                  |
| WAIT_FOR             | fpm:9000      | The webserver waits for the FPM container to be started and answer network calls on Port 9000. Disable with an empty string.                                                                          |
| UPSTREAM_HOST        | fpm:9000      | The upstream host:port for nginx as proxy (nginx `server` directive)                                                                                                                                |

## Default startup scripts

All the scripts in the container's `/data/dockerinit.d` folder are run on each startup:

| Script                  | Description                                                                                                                                                                                   |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 00_enable_site.sh       | Copies and resolves `UPSTREAM_SERVER` with the `APP_FRAMEWORK`.conf file from `nginx/framework-configs` to `nginx/sites.d` where it's picked up by the default `nginx.conf`         |
| 00_wait-for-deps.sh     | Waits for the `WAIT_FOR` server -- by default for the PHP FPM server                                                                                                                        |
| 30_adjust_robots-txt.sh | Creates a "Disallow all" robots.txt file for all environments (defined by `RUNTIME_ENVIRONMENT`) NOT being `local` and `prod`. This prevents search engines to index your DEV/QA sites. |

## Extension points (change or extend configuration)

You can insert your own configuration at these points. Just mount your own config files into these directories or create a derived image from this one and change the files as needed.

| Folder                              | Description                                                                                                                                  |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| /data/conf/nginx/http-partials.d    | `.conf` files here are included by the framework configs at the http (global) level                                                          |
| /data/conf/nginx/server-partials.d  | `.conf` files here are included by the framework configs at the server level                                                                 |
| /data/conf/nginx/security-headers.d | `.conf` files here are included by the server and location configs to extend or override the applied [security headers](security-headers.md) |
| /data/conf/nginx/certificates       | You should mount this directory to a folder on your host system. See the SSL section for further details.                                    |

## SSL support

You can store your own SSL certificates in the folder `/data/conf/nginx/certificates`. The files should be named `cert.pem` and `key.pem`.
If you don't supply your own files, this image will automatically generate a self signed SSL certificate inside this folder. 
The diffie hellman parameter file (`dhparam.pem`) will be also created and stored in this folder if it doesn't exist.

## Framework specific

### Symfony 3

### Symfony 4

### Craft CMS

The nginx config file (`docker/build/assets/data/conf/nginx/framework-configs/craftcms-blitz.conf`) is used for Blitz Cache Plugin configuration.
Cached files are located in `/app/web/cache` directory.

## Contribute!

Contribute to this project and all the other's by creating issues & pull requests.

Thanks for your help!

## Get help

Use the [issue system on Github](https://github.com/iwf-web/docker-nginx) to report errors or suggestions.

You can also write to opensource@iwf.io. We try to answer every question, but it might take some days.
