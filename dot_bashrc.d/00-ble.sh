if [[ ! -f ~/.local/share/blesh/ble.sh ]]; then
  pushd /tmp
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
  make -C ble.sh install PREFIX=~/.local
  popd
fi
source ~/.local/share/blesh/ble.sh
bleopt color_scheme=catppuccin_mocha
