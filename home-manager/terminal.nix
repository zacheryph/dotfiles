{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    atuin
    direnv
  ];

  programs.alacritty = {
    enable = true;
    theme = "catppuccin_macchiato";

    settings = {
      cursor.style = "Beam";

      terminal = {
        shell = {
          program = "/bin/zsh";
          args = [ "-c" "tmux -2 attach" ];
        };
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
        size = 22;
        normal = { family = "Cascadia Code NF"; style = "Light"; };
        bold = { family = "Cascadia Code NF"; style = "Light"; };
        italic = { family = "Cascadia Code NF"; style = "Light"; };

        # size = 20;
        # normal.family = "VictorMono Nerd Font Mono";
        # bold = { family = "VictorMono Nerd Font Mono"; style = "Regular"; };
        # italic.family = "VictorMono Nerd Font Mono";

        # size = 22;
        # normal.family = "DankMono Nerd Font Mono";
        # bold = { family = "DankMono Nerd Font Mono"; style = "Regular"; };
        # italic.family = "DankMono Nerd Font Mono";
      };

      selection = {
        save_to_clipboard = true;
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
      tmuxPlugins.catppuccin
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
    ];

    extraConfig = ''
      # theme settings
      set -g @catppuccin_flavor 'macchiato'

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
      flush-dns = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";

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

    initContent = ''
      function drun() {
        docker run --rm -it --user $(id -u):$(id -g) -v $PWD:/data --workdir /data "$@"
      }

      source <(/opt/homebrew/bin/brew shellenv)
      source <(atuin init zsh)
      source <(direnv hook zsh)
      source <(flux completion zsh)
      source <(kubectl completion zsh)
      source <(mise activate zsh)

      bindkey "^[[1;2C" forward-word
      bindkey "^[[1;2D" backward-word

      # force system paths to the back of the bus
      SYSTEM_PATH=$(eval $(env PATH= /usr/libexec/path_helper -s); echo $PATH)
      PATH=''${PATH//''${SYSTEM_PATH}:/}:''${SYSTEM_PATH}
    '';

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
  };
}
