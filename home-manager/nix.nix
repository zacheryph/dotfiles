{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-zsh-completions
  ];
}
