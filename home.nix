{ config, lib, pkgs, ... }:

let
  localOverrides = ./local.nix;
in
{
  imports = [
    config/nix/common.nix
    config/nix/coding.nix
    config/nix/golang.nix
    config/nix/terminal.nix
    config/nix/macos.nix
    # config/nix/neovim.nix
  ]
  ++ lib.optionals (__pathExists localOverrides) [localOverrides];

  home.stateVersion = "22.05";
}
