#!/bin/bash

# This script deletes unneeded packages for running and removes sudo & apk
sudo apk del openssl netcat-openbsd apk-tools sudo
