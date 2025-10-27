{ pkgs, ... }: {
  home.packages = with pkgs; [
    # general
    shared-mime-info

    # utility
    fd
    go-task
    jq
    overmind
    ripgrep
    shellcheck
    yq-go

    # dev
    mise
    pgcli
    rustup
    valkey # for redis-cli

    # git[hub]
    gh
    git-lfs
    gitAndTools.git-extras
    gitAndTools.gitflow
    gitAndTools.pre-commit
  ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Zachery Hostens";
      alias = {
        co = "checkout";
        st = "status";
        ci = "commit -s";
        b = "branch -v -a";
        lb = "branch -v";
        mb = "merge-base";
        cp = "cherry-pick";
        l = "log --graph --decorate";
        ru = "remote update --prune";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
      };

            # git settings
      help.autocorrect = 2;
      init.defaultBranch = "main";
      log.date = "iso";
      merge.conflictstyle = "zdiff3";
      merge.log = true;
      pull.ff = "only";
      push.default = "current";
      rebase.autostash = true;
      rerere.enabled = true;

      core = {
        packedGitLimit = "1g";
        quotePath = false;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };

      color = {
        branch = true;
        diff = true;
        editor = "nvim";
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

      diff = {
        algorithm = "histogram";
        renames = "copies";

        age.textconv = "cat";
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

      lfs = {
        repositoryformatversion = 0;
      };

      filter = {
        "age" = {
          clean = "age -R .recipients -a -";
          smudge = "age -d -i \${AGE_IDENTITY_FILE} -";
          required = true;
        };
        "lfs" = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
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
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "Mine";
          filters = "is:open author:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me -author:app/renovate";
        }
      ];
    };
  };
}
