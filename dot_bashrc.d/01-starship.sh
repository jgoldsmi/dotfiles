if ! command -v starship 2>&1 >/dev/null; then
  mise use -g starship
fi
eval "$(starship init bash)"
