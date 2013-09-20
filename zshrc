#~/.zshrc
COMPLETION_WAITING_DOTS=true

# Bootstrap antigen
function update_scripts {
    curl https://raw.github.com/zsh-users/antigen/master/antigen.zsh > ~/dotfiles/antigen.zsh
}

if [[ ! -e ~/dotfiles/antigen.zsh ]]; then
    update_scripts
fi
source ~/dotfiles/antigen.zsh

antigen use oh-my-zsh

# Plugins from oh-my-zsh
antigen bundle brew
antigen bundle git

# Plugins from zsh-users
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle sharat87/zsh-vim-mode
antigen bundle rupa/z

antigen theme ys

antigen apply

# Keybindings for zsh-history-substring-search
# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Set up for z
add-zsh-hook precmd _z_precmd
function _z_precmd {
_z --add "$PWD"
}

# History options
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups hist_append share_history extended_history

setopt autocd extendedglob
unsetopt beep
bindkey -v

# prompt stuff
autoload -U promptinit
promptinit

autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

# Need this, so the prompt will work
setopt prompt_subst

# let's load colors into our environment, then set them
autoload colors

if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi

# colorful listings
zmodload -i zsh/complist
if type dircolors > /dev/null 2>&1; then
    eval `dircolors -b`
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# Don't complete CVS directories
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# completion for ssh known_hosts
local _myhosts
_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*' hosts $_myhosts

# zmv "programmable rename"
# autoload -U zmv

autoload -U compinit
compinit

setopt ignoreeof
setopt correctall
setopt autocd
setopt auto_resume
setopt extendedglob

# Quick change directories
function rationalize-dot {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalize-dot
bindkey . rationalize-dot

# aliases
alias apt-cache='nocorrect apt-cache'
alias cp='nocorrect cp'
alias ln='nocorrect ln'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'       # no spelling correction on mv
alias j=jobs
alias sl=ls
if ls -F --color=auto >&/dev/null; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -G -F"
fi
alias ll="ls -l"
alias md='mkdir -p'
alias rd='rmdir'
alias cd..='cd ..'
alias ..='cd ..'
alias :q=exit
if which ack-grep &> /dev/null; then
    alias ack='ack-grep'
fi
alias gg='ack'
alias exot=exit
alias exut=exit
alias ec='emacsclient -n'
alias tmux='TERM=xterm-256color tmux -2'

# Push and pop directories on directory stack
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
alias d='dirs -v'
alias pu='pushd'
alias po='popd'
alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

function cdl { cd $@; ls; }
function mdc { mkdir -p "$1" && cd "$1"; }

function rebuild_drupal_tags {
    ctags --PHP-kinds=+cf --exclude="\.svn" --exclude="build" --langmap=php:.php.module.inc.install.lib -R $(pwd)
}

function ifsource {
    [[ -f $1 ]] && source $1
}

function jsonpp {
    if [[ -f $1 ]]; then
        cat $1 | python -m json.tool
    else
        echo "$@" | python -m json.tool
    fi
}

# Vars for CVS
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export BROWSER=firefox

export GEM_HOME=~/.gem
export PATH=~/bin:$PATH:~/.gem/bin

ifsource ~/.zshrc-private
ifsource /etc/zsh_command_not_found
ifsource ~/.rvm/scripts/rvm

if [[ -d "/usr/local/share/zsh-completions" ]]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
