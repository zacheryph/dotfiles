{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;

    extraConfig = ''
      if "test ! -d ~/.tmux/plugins/tpm" \
        "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'"

      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-pain-control'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'arcticicestudio/nord-tmux'

      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'

      set -g base-index 1
      setw -g pane-base-index 1

      # 24 bit true-color
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc,screen-256color:Tc"

      # window titles
      setw -g automatic-rename on
      set -g set-titles on

      # Unbreak Neovim trying to be fancy
      set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      bind -n C-k send-keys "C-l"\; run "tmux clear-history"

      run '~/.tmux/plugins/tpm/tpm'

      # TODO: need to be able to set name from machine.
      new-session -d -s 16
      new-window -d
      new-window -d
      new-window -d
      new-window -d
    '';
  };
}
