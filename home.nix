{ config, inputs, lib, ... }:
{
  home.stateVersion = "25.05";

  imports =
    [
      home-manager/cloud.nix
      home-manager/common.nix
      home-manager/development.nix
      home-manager/terminal.nix
      home-manager/macos.nix
      home-manager/nix.nix
      home-manager/neovim.nix
    ];
}
