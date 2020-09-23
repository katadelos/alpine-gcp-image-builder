#!/bin/sh
cp /tmp/config/inittab /etc/inittab
cp /tmp/config/sshd_config /etc/ssh/sshd_config
cp /tmp/config/grub /etc/default/grub
grub-mkconfig -o  /boot/grub/grub.cfg
