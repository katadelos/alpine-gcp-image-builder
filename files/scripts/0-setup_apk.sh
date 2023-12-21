#!/bin/sh
echo http://dl-cdn.alpinelinux.org/alpine/v3.19/community >> /etc/apk/repositories
apk add sudo --no-cache
