{ lib, ... }:
let
  localOverrides = ./local.nix;
in {
  imports =
    [
      ./home-manager/common.nix
      ./home-manager/coding.nix
      ./home-manager/terminal.nix
      ./home-manager/macos.nix
      ./home-manager/neovim.nix
    ]
    ++ lib.optionals (__pathExists localOverrides) [localOverrides];

  home.stateVersion = "24.11";
}
