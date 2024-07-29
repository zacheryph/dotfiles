# dotfiles

Dotfiles. all dotfiles and most cli tools are managed via nix and home-manager.
Homebrew is used for Darwin gui applications and _some_ cli tools that do not
exist in nixpkgs or are not kept up to date.

## Bootstrap

This is kept here for one primary reason. For how frequently it gets done, its
not worth scripting. For there is a 99% chance something will have changed
since the last time it was done.

```shell
# clone repository

# install nix using determinate systems installer
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix \
  | sh -s -- install

# open up a new terminal in dotfiles

# create symlinks
ln -s ~/.config/home-manager $(pwd)

# install homebrew

# initialize / install nix-darwin
cd ~/src/dotfiles
nix run nix-darwin -- --flake .

# initialize home-manager
home-manager switch

# clean the garbage
nix-collect-garbage --delete-older-than 14d

# re-open alacritty
```

## Update
```shell
## System Refresh
darwin-rebuild switch --flake ${DOTFILES}

## Home Refresh
home-manager switch
```


### Nix
> https://nixos.org/manual/nix/stable/#sect-macos-installation
```bash
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```

### Home-Manager
> https://github.com/nix-community/home-manager#installation
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
```

### Homebrew
> https://brew.sh/
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
### Bundle
> home-manager sets `HOMEBREW_BUNDLE_FILE` which informs brew where to find our bundle file.
```bash
brew bundle --verbose
```

### Manual
> This is stuff thats currently manual and cannot be automated... yet
* Authenticate
  * Bitwarden
  * Discord
  * Signal
  * Slack
* Download
  * Dank Mono [https://app.gumroad.com/library]

### NodeJS
NodeJS is garbage. Nix' `yarn` hard links to node-14, brew `yarn` depends on `node` which
is always latest. I want stable. So you have to install `node@16 yarn` remove `node`, and
then `link --overwrite node@16` (at least for now)

## Upgrading

Steps to upgrade all packages until I decide how to automate it

```shell
nix-channel --update
home-manager switch
brew upgrade
rustup update
nix-collect-garbage --delete-older-than 14d
```

## Thanks

Current dotfiles owe thanks to [https://github.com/biosan/dotfiles].
