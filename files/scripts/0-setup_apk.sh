#!/bin/sh
echo http://dl-cdn.alpinelinux.org/alpine/v3.12/community >> /etc/apk/repositories
apk add sudo --no-cache
