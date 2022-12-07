#!/bin/bash
mkdir -p ~/.leovim && cd ~ && tar cvzf --exclude=".git" ~/.leovim/leovim.tar.gz ~/.local ~/.leovim.conf ~/.leovim.d
