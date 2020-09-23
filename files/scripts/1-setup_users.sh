#!/bin/sh
USERNAME=$1
USERPASS=$2

validate_pubkeys() {
  if ! ssh-keygen -l -f  $1 2>/dev/null; then
    echo "authorized_keys invalid, quitting!"
    exit 1
  fi
}

validate_pubkeys /tmp/config/authorized_keys

echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel
adduser $USERNAME --disabled-password
echo "${USERNAME}:${USERPASS}" | chpasswd
mkdir /home/${USERNAME}/.ssh
chmod 700 /home/${USERNAME}/.ssh
chown -R ${USERNAME} /home/${USERNAME}/.ssh
cp /tmp/config/authorized_keys /home/${USERNAME}/.ssh/authorized_keys
adduser ${USERNAME} wheel

# Setup base user profile
cp /tmp/config/profile /etc/profile
cp /etc/profile /root/.profile
cp /etc/profile /home/${USERNAME}/.profile

# Setup base ashrc
cp /tmp/config/ashrc /etc/ashrc
cp /tmp/config/ashrc /root/.ashrc
cp /tmp/config/ashrc /home/${USERNAME}/.ashrc
