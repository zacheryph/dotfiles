{ config, pkgs, ... }:

# home-manager programs.neovim does not
# support init.lua so we do... this.
{
  home.packages = with pkgs; [
    neovim-unwrapped
  ];

  xdg.configFile.nvim = {
      source = ../neovim;
    recursive = true;
  };
}
