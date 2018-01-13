#!/bin/bash

[[ "${USERID:-""}" =~ ^[0-9]+$ ]] && usermod -u $USERID -o docker
[[ "${GROUPID:-""}" =~ ^[0-9]+$ ]] && groupmod -g $GROUPID -o docker

. /appenv/bin/activate
cd /home/docker
exec ocrmypdf "$@"
