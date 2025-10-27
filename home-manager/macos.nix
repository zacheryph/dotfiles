{ config, pkgs, ... }:

{
  # macos specific packages
  home.packages = with pkgs; [
    reattach-to-user-namespace
  ];
}
