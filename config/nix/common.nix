{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.man.enable = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPATH = "$HOME/.go";
    LANG = "en_US.UTF-8";
    PATH = "$HOME/bin:$HOME/.krew/bin:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/.nix-profile/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin";
  };

  home.packages = with pkgs; [
    # yes nix. we depend on nix.
    nix

    # general
    bat
    cloc
    dos2unix
    envsubst
    exa
    htop
    nix-zsh-completions
    pinentry_mac
    pwgen-secure
    silver-searcher
    unixtools.watch
    wget

    # media
    ffmpeg
    youtube-dl

    # network
    minio-client
    mtr
    nmap
    wget
  ];

  programs.gpg = {
    enable = true;

    scdaemonSettings = {
      disable-ccid = true;
    };
  };
}
