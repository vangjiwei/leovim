#!/usr/bin/env sh
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

rm $HOME/.vimrc
rm $HOME/.gvimrc
rm $HOME/.ideavimrc
rm $HOME/.config/nvim/init.vim
rm $HOME/.config/nvim/ginit.vim

rm -rf $HOME/.leovim*
