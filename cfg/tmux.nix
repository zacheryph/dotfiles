{ pkgs, ... }:

{
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
      set -ga terminal-overrides ",xterm-256color:Tc,screen-256color:Tc"

      # window titles
      setw -g automatic-rename on
      set -g set-titles on

      # Unbreak Neovim trying to be fancy
      set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      bind -n C-k send-keys "C-l"\; run "tmux clear-history"

      # TODO: need to be able to set name from machine.
      new-session -d -s 16
      new-window -d
      new-window -d
      new-window -d
      new-window -d
    '';
  };
}
