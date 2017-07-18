#!/usr/bin/env bash
# set -e

## SETTINGS
GOLANG_VERSION=1.8.3
##

read -r -d '' USAGE <<EOF
setup: run any/all setup needed for a fresh install

notes:
  * currently only supports debian
  * this is for me. if you dont like it, tough
  * assumes current user is "only" user (will sudo for what it needs)
  * this is tailered around an XPS 13 Touch (QHD)

usage:
  setup.sh <command>

commands:
  all       - run all setups
  base      - install base/need/want to have packages
              this should get smaller as stuff moves to docker
  console   - setup console fonts / etc
  docker    - setup docker installation
  dotfiles  - install dotfiles
  golang    - install latest golang
  gui       - setup x11, boot ui, display manger
  shell     - setup my zsh shell and oh-my-zsh
  sudo      - setup sudo access for user (good to run first)
  wifi      - setup roaming wifi profile
              allows installation of initial networks as well
EOF

USER=$(id -un)

usage() {
  echo "${USAGE}"
  exit
}

run_all() {
  run_sudo
  run_wifi
  run_base
  run_golang
  run_console
  run_gui
  run_docker
  run_shell
  run_dotfiles
}

run_base() {
  sudo apt update

  sudo apt install -y --no-install-recommends \
    alsa-utils \
    apparmor \
    apt-transport-https \
    bridge-utils \
    bzip2 \
    ca-certificates \
    cgroupfs-mount \
    coreutils \
    curl \
    dirmngr \
    dnsutils \
    firmware-misc-nonfree \
    fonts-powerline \
    git \
    gnupg \
    gnupg-agent \
    gnupg2 \
    grep \
    gzip \
    hostname \
    hwinfo \
    iptables \
    jq \
    less \
    libapparmor-dev \
    lightdm \
    make \
    net-tools \
    network-manager \
    pinentry-curses \
    rxvt-unicode-256color \
    silversearcher-ag \
    software-properties-common \
    ssh \
    strace \
    sudo \
    tar \
    tmux \
    tree \
    tzdata \
    unzip \
    vim \
    xbacklight \
    xcape \
    xclip \
    xcompmgr \
    xinput \
    xserver-xorg-input-synaptics \
    xz-utils \
    zip \
    zsh
}

run_console() {
  echo "Select Terminus & 16x32"
  sleep 3
  sudo dpkg-reconfigure console-setup
}

run_docker() {
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian
    $(lsb_release -cs)
    stable"

  sudo apt install -y --no-install-recommends docker-ce

  sudo chown :docker /etc/docker
  sudo chmod g+x /etc/docker
}

run_dotfiles() {
  echo "dotfiles"
}

run_golang() {
  tmpfile=$(mktemp --tmpdir golang-XXXXXX)
  curl -o $tmpfile https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xf $tmpfile
  rm -f $tmpfile
}

read -r -d '' INITRAMFS_MODULES <<EOF
intel_agp
drm
i915 modeset=1
EOF

run_gui() {
#  /etc/initramfs-tools/modules
  sudo apt install -y --no-install-recommends \
    grub-splashimages \
    plymouth \
    plymouth-themes \
    xorg \
    xserver-xorg \
    xserver-xorg-video-intel \
    lightdm \
    feh \
    i3 \
    i3lock \
    i3status \
    scrot

  sudo cp /etc/default/grub /etc/default/grub.setup-backup
  cat /etc/default/grub \
    | sed -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 splash\"/" \
    | sed -e 's/GRUB_GFXMODE=.*/GRUB_GFXMODE=1024x768-32/' \
    | sudo dd status=none of=/etc/default/grub

  echo "GRUB_BACKGROUND=/usr/share/images/grub/Plasma-lamp.tga" \
    | sudo dd status=none conv=notrunc oflag=append of=/etc/default/grub

  echo "$INITRAMFS_MODULES" \
    | sudo dd status=none conv=notrunc oflag=append of=/etc/initramfs-tools/modules

  sudo plymouth-set-default-theme -R spinfinity
  sudo update-grub
}

run_shell() {
  echo "shell"
}

read -r -d '' SUDOERS_TEMPLATE <<EOF
Defaults secure_path=\"/usr/local/go/bin:/home/${USER}/bin:/home/${USER}/.go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"
Defaults env_keep += \"ftp_proxy http_proxy https_proxy no_proxy GOPATH EDITOR\"

${USER} ALL=(ALL) NOPASSWD:ALL
${USER} ALL=NOPASSWD: /sbin/ifconfig, /sbin/ifup, /sbin/ifdown, /sbin/ifquery
EOF

run_sudo() {
  echo "== requesting root password to install and configure sudo"
  su - root -c "apt update \
    && apt install sudo \
    && echo \"${SUDOERS_TEMPLATE}\" \
      | dd status=none of=/etc/sudoers.d/${USER}"
}

run_wifi() {
  echo "wifi"
}



# fonts
# xorg.conf
# grub resolution
# booting

# sudo

# docker

# oh-my-zsh properly

# xorg configs

[[ -z "$1" ]] && usage
case "$1" in
  all)
    run_all
    ;;
  base)
    run_base
    ;;
  console)
    run_console
    ;;
  docker)
    run_docker
    ;;
  dotfiles)
    run_dotfiles
    ;;
  golang)
    run_golang
    ;;
  gui)
    run_gui
    ;;
  shell)
    run_shell
    ;;
  sudo)
    run_sudo
    ;;
  wifi)
    run_wifi
    ;;
  *)
    usage
    ;;
esac
