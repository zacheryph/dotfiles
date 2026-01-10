{ config, pkgs, ... }:

{
  xdg.enable = true;
  programs.home-manager.enable = true;
  programs.man.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPATH = "$HOME/.go";
    LANG = "en_US.UTF-8";
  };

  home.sessionPath = [
    "$HOME/.krew/bin"
    "$HOME/.cargo/bin"
  ];

  home.packages = with pkgs; [
    # general
    cloc
    d2
    dos2unix
    envsubst
    htop
    pwgen-secure
    silver-searcher
    unixtools.watch
    wget

    # network
    curl
    minio-client
    mtr
    nmap
    wget
  ];
}
