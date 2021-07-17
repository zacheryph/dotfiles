{ config, pkgs, ... }:

{
  imports = [
    config/nix/common.nix
    config/nix/coding.nix
    config/nix/terminal.nix
    config/nix/macos.nix
  ];

  home.stateVersion = "20.09";
}
