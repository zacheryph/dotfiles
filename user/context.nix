{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;
  home.username = "context";
  home.homeDirectory = "/Users/context";
  home.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../cfg/alacritty.nix
    ../cfg/git.nix
    ../cfg/gpg.nix
    ../cfg/tmux.nix
    ../cfg/zsh.nix
  ];

  programs.man.enable = true;

  home.packages = with pkgs; [
    ### general
    bandwhich
    bat
    cloc
    exa
    htop
    jq
    # minio-client # builder failing
    mtr
    nmap
    pinentry_mac
    pwgen-secure
    tokei
    # topgrade # needed with nix?
    wrk
    youtube-dl

    ### development
    gitAndTools.git-extras
    gitAndTools.gitflow
    # insomnia # linux only
    neovim
    shellcheck
    vim

    ### languages
    go
    nodejs
    yarn

    ### rust
    rustup
    cargo-audit
    cargo-bloat
    cargo-deps
    cargo-expand
    cargo-geiger
    cargo-generate
    cargo-outdated
    cargo-tree
    cargo-udeps
    cargo-watch

    ### cloud tools
    awscli2
    doctl
    fluxctl
    google-cloud-sdk
    istioctl
    kubectl
    kubectx
    kubernetes-helm
    kubeseal
    kustomize
    linkerd
    stern
  ];
}
