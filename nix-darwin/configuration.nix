{ self, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = { config = "aarch64-apple-darwin"; platform = "aarch64-darwin"; };

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "appcleaner"
      "discord"
      "docker"
      "fork"
      "handbrake"
      # "logseq"
      "slack"
      # "utm"
      "visual-studio-code"
      # cask 'bitwarden' # !arm64
      # cask 'keybase' # !arm64
      # cask 'signal' # !arm64
    ];

    masApps = {
      "Bear" = 1091189122;
      "Home Assistant" = 1099568401;
      "WireGuard" = 1451685025;
    };
  };
}
