# If you come from bash you might have to change your $PATH.A
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/home/vagrant/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="af-magic"
# "avit"
#  "powerlevel9k/powerlevel9k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

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
# see "man strftime" for details.
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
#   export EDITOR="vim"
# else
#   export EDITOR="mvim"
# fi

# Compilation flags:
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# Built in aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Useful aliases
alias activate="source venv/bin/activate"
alias vimedit="vim ~/.config/nvim/init.vim"

# Handy shortcuts
alias trivia="cd $HOME/proyect/trivia && activate"

# Vim and vi
alias f="vim"
alias vi="vim"

# Tree that ignores directories that are unuseful
alias itree="tree -I '__pycache__|venv|node_modules'"

# Alias to quit easily tmux panes
alias q="exit"

alias la="ls -a"
alias ln="ls -n"
alias lsna="ls -na"

alias src="source"
alias sl="ls"
alias ks="ls"

alias .="cd .."
alias ..="cd ../../"
alias ...="cd ../../../"
alias ....="cd ../../../../"

alias s="ls"
alias tmuxedit="vim ~/.tmux.conf"
alias cls="clear"
alias rezsh="source ~/.zshrc"
alias zshedit="vim ~/.zshrc"
alias bashedit="vim ~/.zshrc"
alias reload="source ~/.zshrc"

alias envpygen="python3 -m venv venv && source venv/bin/activate"
alias tmuxconf='vim ~/.tmux.conf'
alias vd="deactivate"

# Git
alias g="git status"
alias gl="git branch --verbose --all"
alias gm="git commit --verbose"
alias gma="git add --all && git commit --verbose"
alias gp="git remote prune origin"
alias gp="git diff"


# Util functions to generate proyects


