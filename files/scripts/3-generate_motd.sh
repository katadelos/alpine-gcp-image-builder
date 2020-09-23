cat << EOF > /etc/motd
Welcome to $( grep PRETTY_NAME /etc/os-release | cut -d '"' -f2 ) for GCP!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <http://wiki.alpinelinux.org/>.

EOF
