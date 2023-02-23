if  [ -f "$HOME/.local/bin/nvim.appimage" ] && [ -x "$HOME/.local/bin/nvim.appimage" ];  then
  NVIMCMD="$HOME/.local/bin/nvim.appimage"
elif [ -f "$HOME/.local/nvim-linux64/bin/nvim" ] && [ -x "$HOME/.local/nvim-linux64/bin/nvim" ]; then
  NVIMCMD="$HOME/.local/nvim-linux64/bin/nvim"
elif [ -x "nvim" ]; then
  NVIMCMD="nvim"
else
  echo "nvim not executable"
  return
fi
$NVIMCMD --cmd "let g:preset_group=['coc']" "$@"
