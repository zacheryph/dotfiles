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
# }}}
# Paths {{{
set -gx PATH $GOPATH/bin /usr/local/opt/go/libexec/bin /usr/local/sbin /usr/local/bin $PATH

set -gx ANDROID_HOME /usr/local/opt/android-sdk
set -gx GOPATH $HOME/.go
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

# vim:foldmethod=marker:foldlevel=0
