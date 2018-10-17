# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
# "powerlevel9k/powerlevel9k"
# "af-magic"
# "random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

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
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

#######################################################################
# Set up environment and PATH
#######################################################################

# Functions --- {{{

path_ladd() {
  # Takes 1 argument and adds it to the beginning of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

path_radd() {
  # Takes 1 argument and adds it to the end of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

# Clubhouse story template
clubhouse() {
  echo -e "## Objective\n## Value\n## Acceptance Criteria" | pbcopy
}

# Reload bashrc
so() {
  source ~/.bashrc
}

# Create New Python Repo
function pynew() {
  if [ $# -ne 1 ]; then
    echo "pynew <directory>"
    return 1
  fi
  local dir_name="$1"
  mkdir "$dir_name"
  cd "$dir_name"
  git init

  mkdir instance
  cat > instance/.gitignore <<EOL
*
!.gitignore
EOL

# venv/
ve
# NOTE: not using pyenv right now
# pipenv install
# va
# pydev
# deactivate
# va

# .gitignore
cat > .gitignore <<EOL
# Python
venv/
.venv/
__pycache__/
*.py[cod]
.tox/
.cache
.coverage
docs/_build/
*.egg-info/
.installed.cfg
*.egg
.mypy_cache/
.pytest_cache/
*.coverage*
# Vim
*.swp
# C
*.so
EOL

cat > main.py <<EOL
#!/usr/bin/env python
'''The main module'''
EOL
chmod +x main.py
}

# [optionally] create and activate Python virtual environment
function ve() {
  if [ $# -eq 0 ]; then
    local VENV_NAME="$DEFAULT_VENV_NAME"
  else
    local VENV_NAME="$1"
  fi
  if [ ! -d "$VENV_NAME" ]; then
    echo "Creating new Python virtualenv in $VENV_NAME/"
    python$DEFAULT_PYTHON_VERSION -m venv "$VENV_NAME"
    source "$VENV_NAME/bin/activate"
    pydev
    deactivate
    va
  else
    va
  fi
}


# Open files with gnome-open
function gn() {  # arg1: filename
  gio open $1
}

# activate virtual environment from any directory from current and up
DEFAULT_VENV_NAME=.venv
DEFAULT_PYTHON_VERSION="3"

function pydev() {
  pip install -U pip neovim bpython autopep8 jedi restview
}

function va() {
  if [ $# -eq 0 ]; then
    local VENV_NAME=$DEFAULT_VENV_NAME
  else
    local VENV_NAME="$1"
  fi
  local slashes=${PWD//[^\/]/}
  local DIR="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    if [ -d "$DIR/$VENV_NAME" ]; then
      source "$DIR/$VENV_NAME/bin/activate"
      local DIR_REL=$(realpath --relative-to='.' "$DIR/$VENV_NAME")
      echo "Activated $(python --version) virtualenv in $DIR_REL/"
      return
    fi
    local DIR="$DIR/.."
  done
  echo "no $VENV_NAME/ found from here to OS root"
}

# [optionally] create and activate Python virtual environment
function ve() {
  if [ $# -eq 0 ]; then
    local VENV_NAME="$DEFAULT_VENV_NAME"
  else
    local VENV_NAME="$1"
  fi
  if [ ! -d "$VENV_NAME" ]; then
    echo "Creating new Python virtualenv in $VENV_NAME/"
    python$DEFAULT_PYTHON_VERSION -m venv "$VENV_NAME"
    source "$VENV_NAME/bin/activate"
    pydev
    deactivate
    va
  else
    va
  fi
}

# deactivate virtual environment
function vd() {
  deactivate
}


# create a make file
function mknew(){
  cat > Makefile <<EOL
SHELL=/bin/bash

.PHONY: default
default: ## By default make runs help
help

.PHONY: help
help:
@echo help
EOL
}

function dat(){
  if [ $# -ne 1 ]; then
    echo "dat <file_name>"
    return 1
  fi
  local file_name="$1"
  strfile -c % "$file_name" "$file_name.dat"
}

function chata(){
 local cowsay_quote="$(fortune -s ~/dotfiles/dotfiles/fortunes)"
 if [ "$(uname 2> /dev/null)" != "Linux" ]; then
    echo -e "$cowsay_quote" | cowsay -f $(ls /usr/local/Cellar/cowsay/3.04/share/cows/ | gshuf -n1) | lolcat
  else
    echo -e "$cowsay_quote" | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1) | lolcat
  fi
}

# Git functions
function gadd() {
  git add .
}

# GIT: push current branch from origin to current branch
function push() {
  local current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "$current_branch"
}

# GIT: pull current branch from origin to current branch
function pull() {
  local current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git pull origin "$current_branch"
}

# Creates a simple new flask proyect
function flasknew(){
  if [ $# -ne 1 ]; then
    echo "flasknew <project_name>"
    return 1
  fi
  local proj_name="$1"
  mkdir "$proj_name"
  cd "$proj_name"
  git init

  mkdir instance
  cat > instance/.gitignore <<EOL
*
!.gitignore
EOL

ve
pip install -U Flask

# .gitignore
cat > .gitignore <<EOL
# Python
venv/
.venv/
__pycache__/
*.py[cod]
.tox/
.cache
.coverage
docs/_build/
*.egg-info/
.installed.cfg
*.egg
.mypy_cache/
.pytest_cache/
*.coverage*
# Vim
*.swp
# C
*.so
EOL

# Creates __init__.py file
cat > $proj_name.py <<EOL
#!/usr/bin/env python
"""Basic Flask app"""

from flask import Flask

def create_app():
    """Initializes the flask app"""
    app = Flask(__name__, static_url_path="")
    return app

if __name__ == "__main__":
    FLASK_APP = create_app()
    FLASK_APP.run(host="0.0.0.0", port=80)

EOL
chmod +x $proj_name.py

# Creates the runnable script that exports the flags to run the flask app
cat > run.sh <<EOL
# Runs the flask app
export FLASK_APP=$proj_name
export FLASK_DEBUG=1
export FLASK_ENV=development
flask run

EOL
chmod +x run.sh

}


# Creates a simple new flask backend
# uses SQLAlachemy
function flaskbackend(){
  if [ $# -ne 1 ]; then
    echo "flasknew <project_name>"
    return 1
  fi
  local proj_name="$1"
  mkdir "$proj_name"
  cd "$proj_name"
  git init

  mkdir instance
  cat > instance/.gitignore <<EOL
*
!.gitignore
EOL

ve
pip install -U Flask

# .gitignore
cat > .gitignore <<EOL
# Python
venv/
.venv/
__pycache__/
*.py[cod]
.tox/
.cache
.coverage
docs/_build/
*.egg-info/
.installed.cfg
*.egg
.mypy_cache/
.pytest_cache/
*.coverage*
# Vim
*.swp
# C
*.so
EOL

# Creates __init__.py file
cat > $proj_name.py <<EOL
#!/usr/bin/env python
"""Basic Flask app"""

from flask import Flask

def create_app():
    """Initializes the flask app"""
    app = Flask(__name__, static_url_path="")
    return app

if __name__ == "__main__":
    FLASK_APP = create_app()
    FLASK_APP.run(host="0.0.0.0", port=80)

EOL
chmod +x $proj_name.py

# Creates the runnable script that exports the flags to run the flask app
cat > run.sh <<EOL
# Runs the flask app
export FLASK_APP=$proj_name
export FLASK_DEBUG=1
export FLASK_ENV=development
flask run

EOL
chmod +x run.sh

  # Creates structure directories
  mkdir models
  mkdir routes
  mkdir utils
}


# Easy way to call ssh
function zssh(){
  if [ $# -ne 2 ]; then
    echo "zzsh <key> <server>"
    return 1
  fi
  ssh -i ~/.ssh/$1 root@$2
}

# Uses Cowsay from a custom list of words
function quote() {
  local cowsay_quote="$(fortune | grep -v '\-\-' | grep .)"
  echo -e "$cowsay_quote" | cowsay
}


# }}}
# Exported variable: LS_COLORS --- {{{

# Colors when using the LS command
# NOTE:
# Color codes:
#   0   Default Colour
#   1   Bold
#   4   Underlined
#   5   Flashing Text
#   7   Reverse Field
#   31  Red
#   32  Green
#   33  Orange
#   34  Blue
#   35  Purple
#   36  Cyan
#   37  Grey
#   40  Black Background
#   41  Red Background
#   42  Green Background
#   43  Orange Background
#   44  Blue Background
#   45  Purple Background
#   46  Cyan Background
#   47  Grey Background
#   90  Dark Grey
#   91  Light Red
#   92  Light Green
#   93  Yellow
#   94  Light Blue
#   95  Light Purple
#   96  Turquoise
#   100 Dark Grey Background
#   101 Light Red Background
#   102 Light Green Background
#   103 Yellow Background
#   104 Light Blue Background
#   105 Light Purple Background
#   106 Turquoise Background
# Parameters
#   di 	Directory
LS_COLORS="di=1;34:"
#   fi 	File
LS_COLORS+="fi=0:"
#   ln 	Symbolic Link
LS_COLORS+="ln=1;36:"
#   pi 	Fifo file
LS_COLORS+="pi=5:"
#   so 	Socket file
LS_COLORS+="so=5:"
#   bd 	Block (buffered) special file
LS_COLORS+="bd=5:"
#   cd 	Character (unbuffered) special file
LS_COLORS+="cd=5:"
#   or 	Symbolic Link pointing to a non-existent file (orphan)
LS_COLORS+="or=31:"
#   mi 	Non-existent file pointed to by a symbolic link (visible with ls -l)
LS_COLORS+="mi=0:"
#   ex 	File which is executable (ie. has 'x' set in permissions).
LS_COLORS+="ex=1;92:"
# additional file types as-defined by their extension
LS_COLORS+="*.rpm=90"

# Finally, export LS_COLORS
export LS_COLORS

# }}}
# Exported variables: General --- {{{

# React
export REACT_EDITOR='less'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Configure less (de-initialization clears the screen)
# Gives nicely-colored man pages
export PAGER=less
export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --clear-screen'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# tmuxinator
export EDITOR=vim
export SHELL=bash

# environment variable controlling difference between HI-DPI / Non HI_DPI
# turn off because it messes up my pdf tooling
export GDK_SCALE=0

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# Powerlevel settings
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_DISABLE_RPROMPT=true

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

# POWERLEVEL9K_TIME_FOREGROUND='red'
# POWERLEVEL9K_TIME_BACKGROUND='blue'
# POWERLEVEL9K_VCS_FOREGROUND='021' # Dark blue

# }}}
# Path appends + Misc env setup --- {{{

PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
  export PYENV_ROOT
  path_radd "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
fi

NODENV_ROOT="$HOME/.nodenv"
if [ -d "$NODENV_ROOT" ]; then
  export NODENV_ROOT
  path_radd "$NODENV_ROOT/bin"
  eval "$(nodenv init -)"
fi

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]; then
  path_ladd "$HOME_BIN"
fi

STACK_LOC="$HOME/.local/bin"
if [ -d "$STACK_LOC" ]; then
  path_ladd "$STACK_LOC"
fi

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}

#######################################################################
# Interactive Bash session settings
#######################################################################

# Import from other Bash Files --- {{{

include () {
  [[ -f "$1" ]] && source "$1"
}

include ~/.bash/sensitive

# }}}
# Executed Commands --- {{{

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal

stty -ixon
# chata
# fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1) | lolcat

# }}}
# Aliases --- {{{

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Make "vim" direct to nvim
alias vim=nvim

# ls aliases
alias ll='ls -alF'
alias l='ls -CF'

# Set copy/paste helper functions
# the perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output"

# Useful aliases
alias zshconfig="vim ~/.zshrc"
alias zshrc="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimedit="vim ~/.config/nvim/init.vim"
alias vimrc="vim ~/.config/nvim/init.vim"
alias zshedit="vim ~/.zshrc"

# Handy shortcuts

# Vim and vi
alias f="vim"
alias v="vim"
alias vi="vim"

# Tree that ignores directories that are unuseful
alias itree="tree -I '__pycache__|venv|node_modules'"

# Alias to quit easily tmux panes
alias q="exit"

alias cls="clear"
alias la="ls -a"
alias .a="ls -a"
alias lsna="ls -na"
alias lasn="ls -na"

alias src="source"
alias sl="ls"
alias ks="ls"

alias .="cd .."
alias ..="cd ../../"
alias ...="cd ../../../"
alias ....="cd ../../../../"
alias .....="cd ../../../../../"

alias m="man"
alias s="ls"
alias sl="ls"
alias ks="ls"
alias tedit="vim ~/.tmux.conf"
alias reload="source ~/.zshrc"
alias confter="sudo dpkg-reconfigure console-setup"
alias alacredit="f ~/.config/alacritty/alacritty.yml"
alias t="tmux"
alias dotfiles="cd ~/.dotfiles"

# Git
alias g='git status'
alias gl='git branch --verbose --all'
alias gm='git commit --verbose'
alias gma='git add --all && git commit --verbose'
alias gp='git remote prune origin'
alias gd='git diff'
alias gcim='git commit -m'

alias p="pass"
alias dotfiles="cd ~/dotfiles"

# NPM
alias ns="npm start"

# }}}
# Plugins --- {{{

if [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh

  # BEGIN: List plugins

  # use double quotes: the plugin manager author says we must for some reason
  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "nobeans/zsh-sdkman", as:plugin
  zplug "zpm-zsh/mysql-colorize", as:plugin
  zplug "voronkovich/mysql.plugin.zsh", as:plugin
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf


  #END: List plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load
else
  echo "zplug not installed, so no plugins available"
fi

# }}}

