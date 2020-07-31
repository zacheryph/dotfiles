{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Zachery Hostens";
    userEmail = "zacheryph@gmail.com";

    signing.key = "EB80AB0F6256C899";
    signing.signByDefault = true;

    aliases = {
      co = "checkout";
      st = "status";
      ci = "commit -s";
      b = "branch -v -a";
      mb = "merge-base";
      cp = "cherry-pick";
      l = "log --graph --decorate";
      ru = "remote update --prune";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
    };

    ignores = [
      "*~"
      "*.swp"
      "._*"
      "*.example"
      "*.sample"

      # Apple Specific
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      ".Spotlight-V100"
      ".Trashes"
    ];

    extraConfig = {
      diff.renames = "copies";
      merge.log = true;
      pull.ff = "only";

      core = {
        packedGitLimit = "50m";
        quotePath = false;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };

      color = {
        branch = true;
        diff = true;
        status = true;
      };

      credentials = {
        # TODO: OS specific
        helper = "osxkeychain";

        "https://git-codecommit.us-east-2.amazonaws.com" = {
          helper = [ "" "!aws codecommit credential-helper $@" ];
          useHttpPath = true;
        };
      };

      url = {
        "https://github.com/" = {
          insteadOf = "hub:";
          pushInsteadOf = "hub:";
        };

        "https://gitlab.com/" = {
          insteadOf = "lab:";
          pushInsteadOf = "lab:";
        };
      };
    };
  };
}
