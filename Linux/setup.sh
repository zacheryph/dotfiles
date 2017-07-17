#!/usr/bin/env bash

dpkg-reconfigure console-setup

apt install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  curl

# add docker repo
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian
  $(lsb_release -cs)
  stable"

apt update

apt install -y --no-install-recommends \
  alsa-utils \
  apparmor \
  libapparmor-dev \
  bridge-utils \
  bzip2 \
  cgroupfs-mount \
  coreutils \
  dnsutils \
  gnupg \
  firmware-misc-nonfree \
  gnupg2 \
  dirmngr \
  gnupg-agent \
  grep \
  gzip \
  hostname \
  iptables \
  jq \
  less \
  net-tools \
  network-manager \
  pinentry-curses \
  rxvt-unicode-256color \
  silversearcher-ag \
  ssh \
  make \
  strace \
  zsh \
  xbacklight \
  sudo \
  xserver-xorg-input-synaptics \
  tar \
  fonts-powerline \
  tree \
  xcape \
  tzdata \
  unzip \
  xclip \
  xcompmgr \
  xz-utils \
  zip \
  hwinfo \
  docker-ce \
  git \
  sudo \
  tmux \
  xinput \
  i3

apt install -y xorg xserver-xorg xserver-xorg-video-intel
apt install -y --no-install-recommends feh i3 i3lock i3status vim scrot suckless-tools

# fonts
# xorg.conf
# grub resolution
# booting
#  apt install plymouth plymouth-themes plymouth-theme-hamara grub-splashimages
#  plymouth-set-default-theme -R spinfinity
#  set grub splash
#  update-grub
#  /etc/initramfs-tools/modules

# sudo

# docker
chown :docker /etc/docker
chmod o+x /etc/docker

# oh-my-zsh properly

# xorg configs
