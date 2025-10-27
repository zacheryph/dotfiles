{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nix
    nix-zsh-completions
  ];
}
