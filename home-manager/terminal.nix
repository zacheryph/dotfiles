{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    atuin
    direnv
  ];

  programs.alacritty = {
    enable = true;

    settings = {
      cursor.style = "Beam";
      shell = {
        program = "/bin/zsh";
        args = [ "-c" "tmux -2 attach" ];
      };

      window = {
        padding.x = 2;
        padding.y = 2;
        opacity = 0.90;
        decorations = "buttonless";

        dimensions.columns = 125;
        dimensions.lines = 42;
      };

      font = {
        size = 20;
        normal.family = "VictorMono Nerd Font Mono";
        bold = { family = "VictorMono Nerd Font Mono"; style = "Regular"; };
        italic.family = "VictorMono Nerd Font Mono";

        # size = 22;
        # normal.family = "DankMono Nerd Font Mono";
        # bold = { family = "DankMono Nerd Font Mono"; style = "Regular"; };
        # italic.family = "DankMono Nerd Font Mono";
      };

      selection = {
        save_to_clipboard = true;
      };

      # # nord
      # colors = {
      #   primary = {
      #     background = "0x2E3440";
      #     foreground = "0xD8DEE9";
      #   };
      #   cursor = {
      #     text = "0x2E3440";
      #     cursor = "0xD8DEE9";
      #   };
      #   normal = {
      #     black = "0x3B4252";
      #     red = "0xBF616A";
      #     green = "0xA3BE8C";
      #     yellow = "0xEBCB8B";
      #     blue = "0x81A1C1";
      #     magenta = "0xB48EAD";
      #     cyan = "0x88C0D0";
      #     white = "0xE5E9F0";
      #   };
      #   bright = {
      #     black = "0x4C566A";
      #     red = "0xBF616A";
      #     green = "0xA3BE8C";
      #     yellow = "0xEBCB8B";
      #     blue = "0x81A1C1";
      #     magenta = "0xB48EAD";
      #     cyan = "0x8FBCBB";
      #     white = "0xECEFF4";
      #   };
      # };

      # tokyonight-storm
      colors = {
        primary = {
          background = "0x24283b";
          foreground = "0xa9b1d6";
        };
        normal = {
          black = "0x32344a";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xad8ee6";
          cyan = "0x449dab";
          white = "0x9699a8";
        };
        bright = {
          black = "0x444b6a";
          red = "0xff7a93";
          green = "0xb9f27c";
          yellow = "0xff9e64";
          blue = "0x7da6ff";
          magenta = "0xbb9af7";
          cyan = "0x0db9d7";
          white = "0xacb0d0";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    shortcut = "a";
    terminal = "tmux-256color";

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.pain-control
      tmuxPlugins.nord
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
    ];

    extraConfig = ''
      # 24 bit true-color
      set -sa terminal-overrides ",alacritty:Tc,xterm-256color:Tc,tmux-256color:Tc"

      # window titles
      setw -g automatic-rename on
      set -g set-titles on

      # copy/pasta
      set -g default-command 'reattach-to-user-namespace $SHELL --login'

      set-option -g focus-events on

      bind -n C-k send-keys "C-l"\; run "tmux clear-history"

      set-option -g status-position top

      new-session -d -s console
      new-window -d
      new-window -d
      new-window -d
      new-window -d
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };

    envExtra = ''
      export BAT_THEME=Nord
      export CASE_SENSITIVE="true"
      export COMPLETION_WAITING_DOTS="true"
      export DISABLE_UNTRACKED_FILES_DIRTY="true"
      export GPG_TTY=$(tty)
      export HIST_STAMPS="yyyy-mm-dd"
      export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
    '';

    shellAliases = {
      # misc
      batl = "bat -l yaml";
      batn = "bat -l json";
      pwgen = "echo $(date +%s)$(gpg --gen-random 30) | sha256sum | base64 | head -c 32 ; echo";
      dequarantine = "sudo xattr -r -d com.apple.quarantine";

      # docker helpers
      up = "docker-compose up -d";

      # work
      be = "bundle exec";
      beg = "bundle exec guard";
      ber = "bundle exec rspec";

      # kubernetes
      fres = "flux reconcile source";
      frek = "flux reconcile kustomization";
      frer = "flux reconcile hr";
      k = "kubectl";
      kap = "k apply -f";
      kctx = "k config use-context";
      kd = "k describe";
      ke = "k explain";
      ker = "k explain --recursive";
      kg = "k get";
      kga = "kg --all-namespaces";
      kns = "k config set-context --current --namespace";
      kr = "k run";
      ktc = "k create --dry-run=client --output=yaml";
      ktr = "k run --dry-run --output=yaml";
      kts = "k expose --dry-run --output=yaml";
      kseal = "kubeseal --format=yaml";
    };

    initExtra = ''
      function drun() {
        docker run --rm -it --user $(id -u):$(id -g) -v $PWD:/data --workdir /data "$@"
      }

      source <(atuin init zsh)
      source <(direnv hook zsh)
      source <(flux completion zsh)
      source <(kubectl completion zsh)
      source <(mise activate zsh)
      source <(/opt/homebrew/bin/brew shellenv)

      bindkey "^[[1;2C" forward-word
      bindkey "^[[1;2D" backward-word

      # force system paths to the back of the bus
      SYSTEM_PATH=$(eval $(env PATH= /usr/libexec/path_helper -s); echo $PATH)
      PATH=''${PATH//''${SYSTEM_PATH}:/}:''${SYSTEM_PATH}
    '';

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
      {
        name = "gitster-theme";
        file = "gitster.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "malnick";
          repo = "zsh-gitster-theme";
          rev = "d670b53a11977ea07583ab5b21bd0a84ccb909d4";
          sha256 = "0c49zkqhjz0a3xn5s1jn4c5qkxs7givs6ddjlyn8ijf8h2qcd3ig";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "colored-man-pages"
        "docker"
        "doctl"
        "helm"
        "macos"
        "systemadmin"
        # "gcloud" # error looking for homebrews /usr/local/Caskroom
        "git-extras"
        "gpg-agent"
      ];
    };
  };
}
