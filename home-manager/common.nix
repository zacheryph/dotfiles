{ config, pkgs, ... }:

{
  # programs.home-manager.enable = true;
  programs.man.enable = true;

  # home.username = builtins.getEnv "USER";
  # home.homeDirectory = builtins.getEnv "HOME";

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
    bat
    cloc
    d2
    dos2unix
    envsubst
    htop
    nix-zsh-completions
    pinentry_mac
    pwgen-secure
    silver-searcher
    unixtools.watch
    wget

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

    settings = {
      auto-key-retrieve = true;
      default-new-key-algo = "ed25519/cert";
      keyserver-options = "honor-keyserver-url";
    };
  };
}
