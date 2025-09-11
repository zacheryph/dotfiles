{ self, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Determinate runs its own nixd now
  nix.enable = false;

  # allow touchid for sudo commands
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
    reattach = true;
  };

  # allow the following commands without a password
  security.sudo.extraConfig = ''
    context ALL=(root) NOPASSWD: /usr/bin/dscacheutil -flushcache
    context ALL=(root) NOPASSWD: /usr/bin/killall -HUP mDNSResponder
    context ALL=(root) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild switch --flake *
  '';

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # We must tell darwin the primary user. this is ugly
  # and should pull from username within flake.nix.
  system.primaryUser = "context";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "font-cascadia-code-nf"
      "font-monaspace-nf"
      "font-victor-mono-nerd-font"
      "fork"
      "slack"
      "visual-studio-code"
    ];
  };
}
