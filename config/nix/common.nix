{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.man.enable = true;

  home.username = "context";
  home.homeDirectory = "/Users/context";

  home.sessionVariables = {
    EDITOR = "vim";
    GOPATH = "$HOME/.go";
    LANG = "en_US.UTF-8";
    PATH = "$HOME/bin:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/.nix-profile/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin";
  };

  home.packages = with pkgs; [
    # general
    bat
    cloc
    dos2unix
    envsubst
    exa
    htop
    minio-client
    nix-zsh-completions
    pinentry_mac
    pwgen-secure
    silver-searcher
    unixtools.watch
    wget
    wrk

    # media
    ffmpeg
    youtube-dl

    # network
    mtr
    nmap
    # minio-client
    wget
  ];

  programs.gpg = {
    enable = true;
  };
}
