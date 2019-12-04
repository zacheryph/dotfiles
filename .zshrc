# Bootstrap oh-my-zsh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  mkdir -p $HOME/.oh-my-zsh/custom/plugins
  mkdir -p $HOME/.oh-my-zsh/custom/themes
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/
  git clone https://github.com/zsh-users/zsh-syntax-highlighting  $HOME/.oh-my-zsh/custom/plugins/
  curl -o $HOME/.oh-my-zsh/custom/themes/gitster.zsh-theme https://raw.githubusercontent.com/shashankmehta/dotfiles/master/thesetup/zsh/.oh-my-zsh/custom/themes/gitster.zsh-theme
fi

[ -z "$_ORIGINAL_PATH" ] && export _ORIGINAL_PATH=$PATH
export GOPATH="${HOME}/.go"
export CARGOPATH="${HOME}/.cargo"
export KREWPATH="${KREW_ROOT:-$HOME/.krew}"
export YARNPATH="${HOME}/.yarn"

export PATH=${HOME}/bin:${CARGOPATH}/bin:${GOPATH}/bin:${KREWPATH}/bin:${YARNPATH}/bin:/usr/local/go/bin:$_ORIGINAL_PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#
# geoffgarside, miloshadzic, mrtazz, philips,
ZSH_THEME="gitster"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws colorize colored-man-pages docker docker-compose docker-machine git git-extras git-flow golang kubectl helm)

if [ -z "$_zsh_custom_scripts_loaded" ]; then
  _zsh_custom_scripts_loaded=1
  plugins+=(zsh-autosuggestions zsh-syntax-highlighting)
fi

# rbenv
[ -x "$(command -v rbenv)" ] && eval "$(rbenv init -)"

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR="vim"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
export GPG_TTY=$(tty)

export NVIM_TUI_ENABLE_TRUE_COLOR=1

export HOMEBREW_GITHUB_API_TOKEN=8cb8caf8c48ff75fedf7cd76c96731f5fef5210b
export GITHUB_API_TOKEN=c3c8bebaee519a82f4b83de6f5a34954d36cee87

# Aliases
# alias vim="nvim"
alias fig="docker-compose"
alias ranpass="ruby -r securerandom -e 'puts SecureRandom.urlsafe_base64'"
alias dotfile="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

if [ -e "${CARGOPATH}/bin/bat" ]; then
  alias cat="${CARGOPATH}/bin/bat"
fi

function dr() {
  docker run --rm -it --user $(id -u):$(id -g) -v ${PWD}:/data --workdir /data "$@"
}

function goto() {
  paths=("$GOPATH/src/git.zro.io" "$GOPATH/src/github.com/zro" "$GOPATH/src/github.com/zacheryph")
  repo=$(find "$paths[@]" -type d -name $1 | head -1)

  if [[ -n "$repo" ]]; then
    cd "$repo"
  else
    echo "!! Go Project $1 Not Found."
  fi
}

function reset-tmuxline() {
  env TMUX_SET_STATUSLINE=1 vim -c 'Tmuxline airline' -c 'q'
}

function calc() {
  echo "$*" | bc
}
