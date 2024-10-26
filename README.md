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
nix run nix-darwin -- switch --flake .

# initialize home-manager
home-manager switch --flake .

# clean the garbage
nix-collect-garbage --delete-older-than 14d

# re-open alacritty
```

## Update
```shell
## Dotfiles
cd ~/src/dotfiles

brew update
nix flake update
darwin-rebuild switch --flake .
home-manager switch --flake .
```
### Manual
> This is stuff thats currently manual and cannot be automated... yet
* Download
  * Dank Mono [https://app.gumroad.com/library]
