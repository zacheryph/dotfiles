# dotfiles

[![Build Status](https://travis-ci.org/zacheryph/dotfiles.svg?branch=master)](https://travis-ci.org/zacheryph/dotfiles)

## Installing

```shell
# dotfiles
ln -s ~/src/dotfiles ~/.config/nixpkgs
ln -s ~/src/dotfiles ~/.nixpkgs

# darwin specific
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
sudo chown -R root:admin /nix
darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin.nix

# home-manager
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Darwin

These packages currently do not have anything in nix. Noted here for manual download.

* Fork
* Keybase
* Monolingual
* Dash
* Insomnia
