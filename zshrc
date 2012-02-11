#~/.zshrc
# History options
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups hist_append share_history

setopt autocd extendedglob
unsetopt beep
bindkey -e

# prompt stuff
autoload -U promptinit
promptinit

# vcs_info settings
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn cvs hg
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash git-remotebranch

# hash changes branch misc
zstyle ':vcs_info:*' formats "[%s|%b] %c%u %m"
zstyle ':vcs_info:*' actionformats "[%s|%b|%a] %c%u %m"

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "+${ahead}" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

function +vi-git-remotebranch() {
    local remote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        hook_com[branch]="${hook_com[branch]} [${remote}]"
    fi
}

function my_precmd {
    # Get version control information for several version control backends
    vcs_info
    PR_VCS="${vcs_info_msg_0_}"

    # The following 9 lines of code comes directly from Phil!'s ZSH prompt
    # http://aperiodic.net/phil/prompt/
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    local PROMPTSIZE=${#${(%):--- %D{%R.%S %a %b %d %Y}\! }}
    local PWDSIZE=${#${(%):-%~}}

    if [[ "$PROMPTSIZE + $PWDSIZE" -gt $TERMWIDTH ]]; then
        (( PR_PWDLEN = $TERMWIDTH - $PROMPTSIZE ))
    fi

    # now let's change the color of the path if it's not writable
    if [[ -w $PWD ]]; then
        PR_PWDCOLOR="${PR_BOLD_DEFAULT}"
    else
        PR_PWDCOLOR="${PR_BOLD_YELLOW}"
    fi  

    # set a simple variable to show when in screen
    if [[ -n "${WINDOW}" ]]; then
        PR_SCREEN=" screen:${WINDOW}"
    else
        PR_SCREEN=""
    fi

    # check if jobs are executing
    if [[ ${#jobstates} -gt 0 ]]; then
        PR_JOBS=" jobs:%j"
    else
        PR_JOBS=""
    fi

    # I want to know my battery percentage when running on battery power
    if which acpi &> /dev/null; then
        local BATTSTATE="$(acpi -b)"
        local BATTPRCNT="$(echo ${BATTSTATE[(w)4]}|sed -r 's/(^[0-9]+).*/\1/')"
        if [[ -z "${BATTPRCNT}" ]]; then
            PR_BATTERY=""
        elif [[ "${BATTPRCNT}" -lt 15 ]]; then
            PR_BATTERY="${PR_BOLD_RED} batt:${BATTPRCNT}%%"
        elif [[ "${BATTPRCNT}" -lt 50 ]]; then
            PR_BATTERY="${PR_BOLD_YELLOW} batt:${BATTPRCNT}%%"
        elif [[ "${BATTPRCNT}" -lt 96 ]]; then
            PR_BATTERY=" batt:${BATTPRCNT}%%"
        else
            PR_BATTERY=""
        fi
    fi

    print -Pn "\e]0;%n@%m: %~\a" # Set the xterm title
    if [[ "$TERM" =~ "^screen" ]]; then
        print -Pn "\ekzsh:%3~\e\\" #reset screen hardstatus
    fi
}

add-zsh-hook precmd my_precmd

function my_preexec {
    emulate -L zsh
    local -a cmd; cmd=(${(z)1})
    local CMD=$cmd[1]:t
    if [[ "$TERM" =~ "^screen" ]]; then
        print -Pn "\ek$CMD:%3~\e\\" #set screen hardstatus, usually truncated at 20 chars
    fi
}

add-zsh-hook preexec my_preexec

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
zle-keymap-select() {
    VIMODE="${${KEYMAP/vicmd/ vim:command}/(main|viins)}"
    RPROMPT2="${PR_BOLD_BLUE}${VIMODE}"
    zle reset-prompt
}

zle -N zle-keymap-select

# Need this, so the prompt will work
setopt prompt_subst

# let's load colors into our environment, then set them
autoload colors

if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi

# The variables are wrapped in %{%}. This should be the case for every
# variable that does not contain space.
for COLOR in RED GREEN YELLOW BLUE BLACK; do
    eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
    eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval PR_BOLD_DEFAULT='%{$fg_bold[default]%}'

# Finally, let's set the prompt
PROMPT='${PR_BOLD_RED}<${PR_BOLD_DEFAULT} \
%D{%Y-%m-%d %R.%S}${PR_RED}|${PR_PWDCOLOR}%${PR_PWDLEN}<...<%~%<<\

${PR_BOLD_RED}<\
${PR_BOLD_DEFAULT} %n@%m${PR_RED}|${PR_BOLD_DEFAULT}%h${PR_BOLD_RED}\
%(?.. exit:%?)${PR_BOLD_BLUE}${PR_SCREEN}${PR_JOBS} ${PR_VCS}${PR_BATTERY}\
${PR_BOLD_BLUE}${VIMODE}\

${PR_BOLD_GREEN}>\
%{${reset_color}%} '

# Of course we need a matching continuation prompt
PROMPT2='${PR_BOLD_BLACK}>${PR_GREEN}>${PR_BOLD_GREEN}>\
${PR_BOLD_DEFAULT} %_ ${PR_BOLD_BLACK}>${PR_GREEN}>\
${PR_BOLD_GREEN}>%{${reset_color}%} '

# colorful listings
zmodload -i zsh/complist
eval `dircolors -b`
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
expand-or-complete-with-dots() {
  echo -n "\e[31m...\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots
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
if ls -F --color=auto >&/dev/null; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -F"
fi
alias ll="ls -l"
alias md='mkdir -p'
alias rd='rmdir'
alias cd..='cd ..'
alias ..='cd ..'
alias :q=exit
alias gg='ack-grep'
alias ack='ack-grep'
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

# Aliases for git
alias gco="git checkout"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gb="git branch"
alias gba="git branch -a"
alias ga="git add"
alias gp="git push"
alias gpr="git pull --rebase"
alias gst="git status"
alias gsu="pushd ./\`git rev-parse --show-cdup\` > /dev/null; git submodule update; popd > /dev/null"
alias gm="git merge"
alias grao="git remote add origin"
function gt {
    #Set up tracking for current branch
    local branch_name remote
    remote=${1:-origin}
    branch_name=$(git branch --no-color 2> /dev/null \
        | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    git branch --set-upstream $branch_name $remote/$branch_name
}

function cdl { cd $@; ls; }
function mdc { mkdir -p "$1" && cd "$1"; }

function rebuild_drupal_tags {
    ctags --PHP-kinds=+cf --exclude="\.svn" --exclude="build" --langmap=php:.php.module.inc.install.lib -R $(pwd)
}


# Vars for CVS
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export BROWSER=firefox

export PATH=$PATH:~/.gem/ruby/1.8/bin

if [[ -f ~/.zshrc-private ]]; then
    source ~/.zshrc-private
fi
