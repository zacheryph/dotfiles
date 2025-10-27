{ config, pkgs, ... }:

{
  # macos specific packages
  home.packages = with pkgs; [
    reattach-to-user-namespace
  ];

  programs.git.settings.credentials = {
    # TODO: OS specific
    helper = "osxkeychain";

    "https://git-codecommit.us-east-2.amazonaws.com" = {
      helper = [ "" "!aws codecommit credential-helper $@" ];
      useHttpPath = true;
    };
  };
}
