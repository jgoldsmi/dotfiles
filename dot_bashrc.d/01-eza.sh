if ! command -v eza 2>&1 >/dev/null; then
  mise use -g eza
fi

alias ll='eza -l --icons=auto --group-directories-first'
alias l.='eza -d .*'
alias ls='eza'
alias l1='eza -1'
