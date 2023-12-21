packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "1000M"
}

variable "gcp_password" {
  type    = string
  default = "alpinelinux"
}

variable "gcp_username" {
  type    = string
  default = "gcp"
}

variable "memory" {
  type    = string
  default = "512"
}

variable "root_password" {
  type    = string
  default = "Vt34Khx"
}

variable "vm_name" {
  type    = string
  default = "alpine-3.19.0-x86_64"
}

source "qemu" "alpine_gcp" {
  boot_command      = [
    "root<enter><wait>",
    "export BOOTLOADER=grub<enter>",
    "export ROOTFS=xfs<enter>",
    "export DISKOPTS='-L -s 512 -m sys /dev/vda'<enter>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers<enter><wait>",
    "setup-apkrepos -1<enter><wait5>",
    "setup-alpine -f $PWD/answers<enter><wait5>",
    "${var.root_password}<enter><wait>",
    "${var.root_password}<enter><wait15>",
    "no<enter><wait8>",
    "y<enter><wait>",
    "mount /dev/vda3 /mnt && ",
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config && ",
    "umount /mnt ; reboot<enter>"
  ]
  boot_key_interval = "8ms"
  boot_wait         = "10s"
  communicator      = "ssh"
  disk_interface    = "virtio"
  disk_size         = "${var.disk_size}"
  format            = "raw"
  headless          = "true"
  http_directory    = "http"
  iso_checksum      = "95ed37b1e54b04aad1c6ff54a5fd60d904363a2a8810c3e3dfe4c2a29e94056b"
  iso_url           = "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.0-x86_64.iso"
  net_device        = "virtio-net"
  output_directory  = "build"
  shutdown_command  = "poweroff"
  ssh_password      = "${var.root_password}"
  ssh_timeout       = "2m"
  ssh_username      = "root"
  vm_name           = "disk.raw"
}

build {
  sources = ["source.qemu.alpine_gcp"]

  provisioner "file" {
    destination = "/tmp/"
    source      = "./files/"
  }

  provisioner "shell" {
    inline = [
      "/tmp/scripts/0-setup_apk.sh",
      "/tmp/scripts/1-setup_users.sh ${var.gcp_username} ${var.gcp_password}",
      "/tmp/scripts/2-gcp_config.sh",
      "/tmp/scripts/3-generate_motd.sh"
    ]
  }

}
