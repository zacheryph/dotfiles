{ config, pkgs, ... }:

{
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
        opactity = 0.90;
        decorations = "buttonless";

        dimensions.columns = 124;
        dimensions.lines = 34;
      };

      font = {
        size = 22;
        use_thin_strokes = true;

        normal.family = "Dank Mono";
        bold = { family = "Dank Mono"; style = "Regular"; };
        italic.family = "Dank Mono";
      };

      selection = {
        save_to_clipboard = true;
      };

      # Nord
      colors = {
        primary = {
          background = "0x2E3440";
          foreground = "0xD8DEE9";
        };
        cursor = {
          text = "0x2E3440";
          cursor = "0xD8DEE9";
        };
        normal = {
          black = "0x3B4252";
          red = "0xBF616A";
          green = "0xA3BE8C";
          yellow = "0xEBCB8B";
          blue = "0x81A1C1";
          magenta = "0xB48EAD";
          cyan = "0x88C0D0";
          white = "0xE5E9F0";
        };
        bright = {
          black = "0x4C566A";
          red = "0xBF616A";
          green = "0xA3BE8C";
          yellow = "0xEBCB8B";
          blue = "0x81A1C1";
          magenta = "0xB48EAD";
          cyan = "0x8FBCBB";
          white = "0xECEFF4";
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
    terminal = "screen-256color";

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
      set -sa terminal-overrides ",alacritty:Tc,screen-256color:Tc"

      # window titles
      setw -g automatic-rename on
      set -g set-titles on

      # copy/pasta
      set -g default-command 'reattach-to-user-namespace $SHELL --login'

      set-option -g focus-events on

      bind -n C-k send-keys "C-l"\; run "tmux clear-history"

      # TODO: need to be able to set name from machine.
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
    enableAutosuggestions = true;

    envExtra = ''
      [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

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
      pwgen = "ruby -r securerandom -e 'puts SecureRandom.urlsafe_base64(rand(24..40))'";

      # docker helpers
      up = "docker-compose up -d";
      dockervm = "docker run --rm -it --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n bash";

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

      source <(rbenv init - zsh)
      source <(kubectl completion zsh)
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
