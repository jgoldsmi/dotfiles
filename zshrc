#~/.zshrc
COMPLETION_WAITING_DOTS=true
bindkey -v

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
if [[ $(uname) == 'Darwin' ]]; then
    antigen bundle brew
    antigen bundle osx
fi
antigen bundle extract
antigen bundle git
antigen bundle git-extras
antigen bundle npm
antigen bundle perl
antigen bundle pip
antigen bundle rvm
antigen bundle taskwarrior

# Plugins from zsh-users
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle sharat87/zsh-vim-mode
antigen bundle rupa/z

antigen theme sunrise

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

autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
# Don't complete CVS directories
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'


setopt ignoreeof
setopt auto_resume

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
alias j=jobs
alias sl=ls
if ls -F --color=auto >&/dev/null; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -G -F"
fi
alias ll="ls -l"
alias :q=exit
if which ack-grep &> /dev/null; then
    alias ack='ack-grep'
fi
alias gg='ack'
alias exot=exit
alias exut=exit
alias tmux='TERM=xterm-256color tmux -2'

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
