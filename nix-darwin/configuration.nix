{ self, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # nix-darwin aborts cause the gid is what it wants it to be...
  # https://github.com/LnL7/nix-darwin/issues/1339
  ids.gids.nixbld = 350;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = {
    config = "aarch64-apple-darwin";
    platform = "aarch64-darwin";
  };

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "font-cascadia-code-nf"
      "font-victor-mono-nerd-font"
      "slack"
      "visual-studio-code"
    ];
  };
}
