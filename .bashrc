# ~/.bashrc
# return if not interactive
[ -z "$PS1" ] && return

# History options
export HISTFILE=~/.bash_history
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:[bf]g:[ \t]*:exit"
shopt -s histappend
shopt -s cmdhist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Various bash options
set -o vi
set -o ignoreeof
shopt -s dotglob
shopt -s autocd
shopt -s checkwinsize
shopt -s checkjobs
shopt -s globstar

export PATH=~/bin:/opt/lampp/bin:$PATH
# Vars for Go
export GOROOT=~/src/go
export GOOS=linux
export GOARCH=amd64
export GOBIN=~/bin
# Vars for CVS
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export BROWSER=firefox
export TERM=xterm

export PATH=$PATH:~/.gem/ruby/1.8/bin

# Prompt and set xterm title
export PS1='[\u@\h] \w$(__git_ps1 "(%s)" 2>/dev/null) \\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'


[ -e ~/.bashrc-private ] && . ~/.bashrc-private
