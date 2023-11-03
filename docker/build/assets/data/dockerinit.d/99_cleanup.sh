#!/bin/bash

# This script deletes unneeded packages for running and removes sudo
sudo apk del --no-cache openssl netcat-openbsd sudo
