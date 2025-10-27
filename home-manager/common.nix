{ config, pkgs, ... }:

{
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
    reattach-to-user-namespace
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

  programs.gpg = {
    enable = true;

    scdaemonSettings = {
      disable-ccid = true;
    };

    settings = {
      auto-key-retrieve = true;
      default-new-key-algo = "ed25519/cert";
      keyserver-options = "honor-keyserver-url";
    };
  };
}
