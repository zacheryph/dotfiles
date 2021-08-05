{ config, pkgs, ... }:

{
  home.sessionVariables = {
    HOMEBREW_BUNDLE_FILE = "$HOME/.config/nixpkgs/config/macos/Brewfile";
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
    enable-ssh-support
    default-cache-ttl 300
    default-cache-ttl-ssh 300
    max-cache-ttl 600
    max-cache-ttl-ssh 600
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';

  # macos specific packages
  home.packages = with pkgs; [
    reattach-to-user-namespace
  ];
}
