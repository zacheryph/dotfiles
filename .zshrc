# Bootstrap oh-my-zsh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  mkdir -p $HOME/.oh-my-zsh/custom/plugins
  mkdir -p $HOME/.oh-my-zsh/custom/themes
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/
  git clone https://github.com/zsh-users/zsh-syntax-highlighting  $HOME/.oh-my-zsh/custom/plugins/
  curl -o $HOME/.oh-my-zsh/custom/themes/gitster.zsh-theme https://raw.githubusercontent.com/shashankmehta/dotfiles/master/thesetup/zsh/.oh-my-zsh/custom/themes/gitster.zsh-theme
fi

# Oh My Zsh Options
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="gitster"
CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# plugins=(aws colored-man-pages docker doctl helm osx systemadmin gcloud git-extras gpg-agent zsh-autosuggestions zsh-syntax-highlighting)
plugins=(aws colored-man-pages docker doctl helm osx systemadmin gcloud git-extras gpg-agent zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# local rc file not committed into git
[ -f "${HOME}/.zshrc.local" ] && source "${HOME}/.zshrc.local"

# General Terminal/Environment Setup
export LANG=en_US.UTF-8
export EDITOR="vim"
export GPG_TTY=$(tty)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# [ -x "$(command -v rbenv)" ] && eval "$(rbenv init -)"

# Nix Path
[ -z "$_ORIGINAL_PATH" ] && export _ORIGINAL_PATH=$PATH
export CARGOPATH="${HOME}/.cargo"
export KREWPATH="${KREW_ROOT:-$HOME/.krew}"

# export PATH="${HOME}/bin:${CARGOPATH}/bin:${KREWPATH}/bin:${_ORIGINAL_PATH}"

# The all mighty Path
# export GOPATH="${HOME}/.go"
# export GOBIN="${HOME}/bin"
# export CARGOPATH="${HOME}/.cargo"
# export KREWPATH="${KREW_ROOT:-$HOME/.krew}"
# export WASMTIME_HOME="$HOME/.wasmtime"
#
# [ -z "$_ORIGINAL_PATH" ] && export _ORIGINAL_PATH=$PATH
# export PATH=${HOME}/bin:${CARGOPATH}/bin:${WASMTIME_HOME}/bin:${KREWPATH}/bin:/usr/local/sbin:$_ORIGINAL_PATH

# General Aliases
alias ranpass="ruby -r securerandom -e 'puts SecureRandom.urlsafe_base64'"
alias dotfile="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

function calc() { echo "$*" | bc }
function reset-tmuxline() { env TMUX_SET_STATUSLINE=1 vim -c 'Tmuxline airline' -c 'q' }

# Docker / Cloud Related
alias docker-vm="docker run --rm -it --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n bash"
dr() { docker run --rm -it --user $(id -u):$(id -g) -v ${PWD}:/data --workdir /data "$@" }

# Kubernetes Aliases / Autocompletion
alias k="kubectl"
alias kap="k apply -f"
alias kr="k run"
alias kd="k describe"
alias kg="k get"
alias kga="kg --all-namespaces"
alias kns="k config set-context --current --namespace"
alias ke="k explain"
alias ker="k explain --recursive"
alias ktr="k run --dry-run --output=yaml"
alias ktc="k create --dry-run --output=yaml"
alias kts="k expose --dry-run --output=yaml"
alias kctx="k config use-context"
alias kns="k config set-context --current --namespace"

source <(kubectl completion zsh)
