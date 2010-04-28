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

export PATH=$PATH:~/.gem/ruby/1.8/bin

# Prompt and set xterm title
# Text colors, from archwiki
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset
function prompt_command {
    status="$?"
    exit_status=
    if [[ "$status" -ne 0 ]]; then
        exit_status="${bldred}exit:${status}${txtrst}"
    fi
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007";
    win_num=
    if [[ -n "$WINDOW" ]]; then
        win_num="${bldblu}screen:${WINDOW}${txtrst}"
    fi
    line_1="${bldred}< ${bldwht}\$(date +%Y-%m-%d) \$(date +%H:%M.%S)${txtred}|${bldwht}\w${txtrst}"
    line_2="${bldred}<${bldwht} \u@\h${txtred}|${bldwht}\!${txtrst} ${win_num} ${exit_status}"
    line_3="${bldgrn}>${txtrst} "
    export PS1="${line_1}\n${line_2}\n${line_3}"

}
export PROMPT_COMMAND="prompt_command"

[ -e ~/.bashrc-private ] && . ~/.bashrc-private
