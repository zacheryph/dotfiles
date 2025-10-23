{pkgs, ...}:
# home-manager programs.neovim does not
# support init.lua so we do... this.
{
  home.packages = with pkgs; [
    neovim-unwrapped
    tree-sitter
    ripgrep
    lazygit
    gdu
    bottom
    alejandra # nix
    deadnix # nix
  ];
}
