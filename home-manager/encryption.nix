{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    pinentry_mac
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

  home.file.".gnupg/gpg-agent.conf".text = ''
    enable-ssh-support
    default-cache-ttl 300
    default-cache-ttl-ssh 300
    max-cache-ttl 600
    max-cache-ttl-ssh 600
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';

  programs.zsh.envExtra = ''
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
  '';
}
