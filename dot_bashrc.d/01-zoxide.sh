if ! command -v zoxide 2>&1 >/dev/null; then
  mise use -g fzf
  mise use -g zoxide
fi
eval "$(zoxide init bash)"
