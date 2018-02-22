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
export GOPATH=$HOME/.go
export PATH=$HOME/bin:$GOPATH/bin:/usr/local/go/bin:$_ORIGINAL_PATH


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

if [[ -d /usr/local/var/rbenv ]]; then
  export RBENV_ROOT=/usr/local/var/rbenv
fi

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR="vim"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
export GPG_TTY=$(tty)

export NVIM_TUI_ENABLE_TRUE_COLOR=1

export HOMEBREW_GITHUB_API_TOKEN=8cb8caf8c48ff75fedf7cd76c96731f5fef5210b

# Aliases
# alias vim="nvim"
alias fig="docker-compose"
alias ranpass="ruby -r securerandom -e 'puts SecureRandom.urlsafe_base64'"
alias dotfile="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

function goto() {
  if [[ -d "$GOPATH/src/github.com/zro/$1" ]]; then
    cd $GOPATH/src/github.com/zro/$1
    return
  fi
  if [[ -d "$GOPATH/src/github.com/zacheryph/$1" ]]; then
    cd $GOPATH/src/github.com/zacheryph/$1
    return
  fi
  echo "!! Go Project $1 Not Found."
}

function reset-tmuxline() {
  env TMUX_SET_STATUSLINE=1 vim -c 'Tmuxline airline' -c 'q'
}
