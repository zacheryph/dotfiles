{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      # https://github.com/NixOS/nixpkgs/issues/168984
      golangci-lint = super.golangci-lint.override {
        buildGoModule = super.buildGoModule;
      };
    })
  ];

  home.packages = with pkgs; [
    go
  ];
}

