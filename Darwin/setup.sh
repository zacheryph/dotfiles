#!/bin/bash

### Install Stuff
# Taps
brew tap caskroom/cask
brew tap grpc/grpc
brew tap neovim/neovim

# Casks
brew cask install \
  atom \
  rowanj-gitx \
  google-chrome \
  keybase \
  mocksmtp \
  monolingual \
  transmission \
  transmit \
  vmware-fusion \
  iterm2

# General
brew install \
  cayley \
  cloc \
  stormssh \
  htop \
  ifstat \
  irssi \
  keybase \
  mtr \
  nmap \
  tmux \
  wrk \
  youtube-dl

# Development
brew install \
  elixir \
  git \
  git-extras \
  git-flow \
  glide \
  go \
  grpc \
  google-protobuf \
  neovim \
  python3 \
  rbenv \
  ruby-build \
  the_silver_searcher

brew install vim \
  --with-lua \
  --with-override-system-vi

pip3 install neovim

# Shell
brew install zsh
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells >/dev/null
chsh -s /usr/local/bin/zsh

### Git
git config --global credential.helper=osxkeychain
