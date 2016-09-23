# Bootstrap {{{
if not test -f $HOME/.config/fish/functions/fisher.fish
  echo "==> Installing fisherman"
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end
# }}}
# Defaults {{{
set -gx EDITOR vim
set -gx LSCOLORS Gxfxcxdxbxegedabagacad

# Fix TMUX (https://github.com/tmux/tmux/issues/475)
set -gx EVENT_NOKQUEUE 1
# }}}
# Paths {{{
set -gx ANDROID_HOME /usr/local/opt/android-sdk
set -gx GOPATH $HOME/.go
set -gx PATH $GOPATH/bin /usr/local/opt/go/libexec/bin /usr/local/sbin /usr/local/bin $PATH
# }}}
# Vim / NeoVim {{{
set -gx NVIM_TUI_ENABLE_TRUE_COLOR 1
# }}}
# Ruby {{{
set -gx RBENV_ROOT /usr/local/var/rbenv

status --is-interactive; and . (rbenv init -|psub)
# }}}
# Aliases {{{
alias fig "docker-compose"
alias ranpass "ruby -r securerandom -e 'puts SecureRandom.urlsafe_base64'"
alias dotfile "git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
# }}}
# Man Page Coloring {{{
function man
  env \
    LESS_TERMCAP_md=(printf "\e[1;36m") \
    LESS_TERMCAP_me=(printf "\e[0m") \
    LESS_TERMCAP_se=(printf "\e[0m") \
    LESS_TERMCAP_so=(printf "\e[1;40;92m") \
    LESS_TERMCAP_ue=(printf "\e[0m") \
    LESS_TERMCAP_us=(printf "\e[1;32m") \
    man $argv
end
# }}}
# vim:foldmethod=marker:foldlevel=0
