{ config, pkgs, ... }:
let
  tmux-tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-tokyo-night";
    version = "v1.11.0";
    rtpFilePath = "tmux-tokyo-night.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "fabioluciano";
      repo = "tmux-tokyo-night";
      rev = "v1.11.0";
      sha256 = "sha256-WjDbunWmxbw/jjvc34ujOWif18POC3WVO1s+hk9SLg4=";
    };
  };
in
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
          args = [ "-c" "tmux -2 attach -t console" ];
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
      {
        plugin = tmux-tokyo-night;
        extraConfig = ''
          set -g @theme_variation 'storm'
        '';
      }
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
      new-window -d -t console:2
      new-window -d -t console:3
      new-window -d -t console:4
      new-window -d -t console:5
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      export DISABLE_UNTRACKED_FILES_DIRTY="true"
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

    siteFunctions = {
      drun = '' docker run --rm -it --user $(id -u):$(id -g) -v $PWD:/data --workdir /data "$@" '';
    };

    initContent = ''
      # force system paths to the back of the bus
      SYSTEM_PATH=$(eval $(env PATH= /usr/libexec/path_helper -s); echo $PATH)
      PATH=''${PATH//''${SYSTEM_PATH}:/}:''${SYSTEM_PATH}

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      source <(/opt/homebrew/bin/brew shellenv)
      source <(atuin init zsh)
      source <(direnv hook zsh)
      source <(flux completion zsh)
      source <(kubectl completion zsh)
      source <(mise activate zsh)

      bindkey "^[[1;2C" forward-word
      bindkey "^[[1;2D" backward-word
    '';

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "fast-syntax-highlighting.plugin.zsh";
      }
    ];
  };

  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Macchiato";
    extraPackages = with pkgs.bat-extras; [ batdiff batman ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    colors = "auto";
    git = true;
    icons = "auto";
    theme = "catppuccin";

    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
