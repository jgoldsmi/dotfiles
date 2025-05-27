# mise settings
if ! command -v mise 2>&1 >/dev/null; then
  # Install mise
  curl https://mise.run | sh
  rehash -r
fi
eval "$(mise activate bash)"
