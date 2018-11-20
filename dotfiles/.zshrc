# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

plugins=(
git
)

fpath+=~/.zfunc
source $ZSH/oh-my-zsh.sh

#######################################################################
# Environment Setup
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
  pygnore
  pymain main
  pve
  poedev
}

function pymain() {
  if [ $# -ne 1 ]; then
    echo "main <script_name>"
    return 1
  fi
  cat > $1.py <<EOL
#!/usr/bin/env python
"""The main module"""

def main():
    """Main function"""
    print("Hello")

if __name__ == "__main__":
    main()
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

# Simple function to create virtual environmnents
function pve() {
  if [ $# -eq 0 ]; then
    local VENV_NAME="$DEFAULT_VENV_NAME"
  else
    local VENV_NAME="$1"
  fi
  if [ ! -d "$VENV_NAME" ]; then
    echo "Creating new Python virtualenv in $VENV_NAME/"
    python$DEFAULT_PYTHON_VERSION -m venv "$VENV_NAME"
    source "$VENV_NAME/bin/activate"
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


function poedev() {
  pip install -U poetry
  poetry init
  poetry add neovim autopep8 jedi
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
  if [ $# -ne 1 ]; then
    echo "mknew <project_name>"
    return 1
  fi
  cat > Makefile <<EOL
SHELL=/bin/bash

.PHONY: default
default: ## By default make runs help
        help

.PHONY: help
help: ## Prints target and a help message
        @grep -E '^[a-zA-Z_-]+:.*?## .*\$\$' \$(MAKEFILE_LIST) |  \\
                awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", \$\$1, \$\$2}'


#######################################################################
# Docker
#######################################################################

.PHONY: docker-build
docker-build: ## Build Docker image base
        @docker build -t \$(IMAGE_NAME):base .

.PHONY: docker-run
docker-run:
        @docker run -p 4000:80 -t \$(IMAGE_NAME):base

.PHONY: docker-clean
docker-clean: # Removes all docker images built by this Makefile
        @docker rmi \$(IMAGE_NAME)


#################################################################
# Project
#################################################################

.PHONY: lint
lint:  ## Run lint tools
        @pylint --output-format=colorized main.py
        @mypy main.py

.PHONY: install
install: ## Install the application dependencies
        @poetry install

.PHONY: run
run: ## Run the project
        @python main.py

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

function cowme(){
  local cowsay_quote="$(fortune -s ~/dotfiles/dotfiles/fortunes)"
  if [ "$(uname 2> /dev/null)" != "Linux" ]; then
    echo -e "$cowsay_quote" | cowsay -f $(ls /usr/local/Cellar/cowsay/3.04/share/cows/ | gshuf -n1) | lolcat
  else
    echo -e "$cowsay_quote" | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1) | lolcat
  fi
}

# GIT: git-clone keplergrp repos to src/ directory
function klone() {
  git clone git@github.com:KeplerGroup/$1
}

# GIT: git-add adds all the items to the commit
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

# Create and activate Node virtual environment
function nve() {
  if [ $# -eq 0 ]; then
    local VENV_NAME="$DEFAULT_VENV_NAME"
  else
    local VENV_NAME="$1"
  fi
  if [ ! -d "$VENV_NAME" ]; then
    echo "Creating new node virtualenv in $VENV_NAME/"
    nodeenv "$VENV_NAME"
  else
    echo "Activating new node virtualenv in $VENV_NAME/"
  fi
  source "$VENV_NAME/bin/activate"
}

# deactivate node virtual environment
function nvd() {
  deactivate_node
}


function kzoom() {
  if [ $# -ne 1 ]; then
    echo "kzoom <idx>"
    return 1
  fi
  case "$1" in
    1) echo "Joining TDS link"
      xdg-open $ZOOM_LINK_TDS
      ;;
    2) echo "Joining personal meeting id"
      xdg-open $ZOOM_LINK_PERSONAL
      ;;

    esac
  }

  function pygnore() {
    gitignore Python.gitignore > .gitignore
  }

  function dockrmall() {
    docker rmi $(docker images -a -q)
  }

  # Executed at the point where the main shell is about to exit normally.
  function zshexit() {

  }

  # Generates a README.md template for the project
  function readme(){
    cat > README.md <<EOL
# Product Name
> Short blurb about what your product does.

[![NPM Version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Downloads Stats][npm-downloads]][npm-url]

One to two paragraph statement about your product and what it does.

![](header.png)

## Installation

OS X & Linux:

```sh
npm install my-crazy-module --save
```

Windows:

```sh
edit autoexec.bat
```

## Usage example

A few motivating and useful examples of how your product can be used. Spice this up with code blocks and potentially more screenshots.

_For more examples and usage, please refer to the [Wiki][wiki]._

## Development setup

Describe how to install all development dependencies and how to run an automated test-suite of some kind. Potentially do this for multiple platforms.

```sh
make install
npm test
```

## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
* The first proper release
* CHANGE: Rename `foo()` to `bar()`
* 0.0.1
* Work in progress

## Meta

Your Name – [@YourTwitter](https://twitter.com/dbader_org) – YourEmail@example.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
EOL
}

# Necessary files for project start
function base-proj() {
  pynew
}
# Print out the Github-recommended gitignore
export GITIGNORE_DIR=$HOME/src/lib/gitignore
function gitignore() {
  if [ ! -d "$GITIGNORE_DIR" ]; then
    mkdir -p $HOME/src/lib
    git clone https://github.com/github/gitignore $GITIGNORE_DIR
    return 1
  elif [ $# -eq 0 ]; then
    echo "Usage: gitignore <file1> <file2> <file3> <file...n>"
    return 1
  else
    # print all the files
    local count=0
    for filevalue in $@; do
      echo "#################################################################"
      echo "# $filevalue"
      echo "#################################################################"
      cat $GITIGNORE_DIR/$filevalue
      if [ $count -ne $# ]; then
        echo
      fi
      (( count++ ))
    done
  fi
}
compdef "_files -W $GITIGNORE_DIR/" gitignore

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
#   1  Red
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

# Poetry auto-completion
# poetry completions zsh > ~/.zfunc/_poetry

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
alias lls="ll"
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
alias gcheckout='git checkout'
alias gremote='git remote'
alias fetch='git fetch'
alias stash='git stash'

alias p="pass"
alias dotfiles="cd ~/dotfiles"
alias sensitive="vim ~/.bash/sensitive"

# Pylint
alias pylint="pylint --output-format=colorized"

# NPM
alias ns="npm start"
alias ni="npm install"
alias nu="npm uninstall"
alias na="npm audit"

alias vpn_aws='sudo openvpn --config $HOME/openvpn/openvpn.conf'

# Pip
alias pipi="pip install"
alias pipir="pip install -r"

# Poetry
alias ponew="poetry new"
alias poadd="poetry add"
alias poins="poetry install"
alias porm="poetry remove"
alias poupd="poetry update"
alias posear="poetry search"

# postgres
alias psqlu="psql -U postgres -W"
alias pgcliu="pgcli -U postgres -W"

# Quick visited paths
alias konrad="cd $HOME/src/Konrad"
alias kepler="cd $HOME/src/Kepler"
alias standups="cd $HOME/Kepler/standups"
alias kaws="xdg-open https://keplergroup.signin.aws.amazon.com/console"

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
  # zplug "zpm-zsh/mysql-colorize", as:plugin
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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kjimenez/google-cloud-sdk/path.zsh.inc' ]; then source '/home/kjimenez/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kjimenez/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/kjimenez/google-cloud-sdk/completion.zsh.inc'; fi
