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
    ../cfg/vim.nix
    ../cfg/zsh.nix
  ];

  programs.man.enable = true;

  home.packages = with pkgs; [
    ### general
    bandwhich
    bat
    cloc
    envsubst
    exa
    gomplate
    go-task
    htop
    jq
    # minio-client # broken
    mtr
    nmap
    pinentry_mac
    pwgen-secure
    silver-searcher
    tokei
    unixtools.watch
    wrk
    youtube-dl
    yq-go

    ### development
    drone-cli
    gitAndTools.git-crypt
    gitAndTools.git-extras
    gitAndTools.gitflow
    gitAndTools.pre-commit
    # insomnia # linux only
    neovim
    shellcheck

    ### languages
    go
    nodejs
    yarn

    ### ruby
    ruby
    rubyPackages.rubocop
    rubyPackages.rubocop-performance
    bundler-audit

    ### rust
    rustup
    cargo-audit
    cargo-bloat
    cargo-deps
    cargo-edit
    cargo-expand
    cargo-geiger
    cargo-generate
    cargo-outdated
    cargo-sweep
    cargo-udeps
    cargo-watch
    wasm-pack

    ### network
    iperf

    ### cloud tools
    awscli2
    doctl
    fluxctl
    google-cloud-sdk
    istioctl
    # kube3d
    kubectl
    kubectx
    kubeval
    kubernetes-helm
    kubeseal
    kustomize
    linkerd
    stern
    wrangler
  ];
}
