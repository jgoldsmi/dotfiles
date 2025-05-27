# Depends on 00-ble.sh
if ! command -v atuin 2>&1 >/dev/null; then
  mise use -g aqua:atuinsh/atuin
fi
eval "$(atuin init bash)"
