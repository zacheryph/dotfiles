{ config, inputs, lib, ... }:
{
  home.stateVersion = "24.11";

  imports =
    [
      home-manager/cloud.nix
      home-manager/common.nix
      home-manager/development.nix
      home-manager/terminal.nix
      home-manager/macos.nix
      home-manager/neovim.nix
    ];
}
