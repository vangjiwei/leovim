# plug.vim 
curl -fLo ../../../pack/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sed -i -e 's/ *$//g' ../../../pack/plug.vim


# vim-jetpack
rm -rf vim-jetpack
git clone --depth 1 https://github.com/tani/vim-jetpack
sed -i -e 's/40vnew/to 80vnew/g' ./vim-jetpack/plugin/jetpack.vim


# vim-preview
rm -rf vim-preview
git clone --depth 1 https://github.com/leoatchina/vim-preview.git

# eregex.vim 
rm -rf eregex.vim 
git clone --depth 1 https://github.com/othree/eregex.vim.git

# easy-align
rm -rf vim-easy-align
git clone --depth 1 https://github.com/junegunn/vim-easy-align.git

# vim-dict
rm -rf vim-dict
git clone --depth 1 https://github.com/skywind3000/vim-dict.git

# conflict-marker
rm -rf conflict-marker.vim
git clone --depth 1 https://github.com/rhysd/conflict-marker.vim.git

# easymotion
rm -rf vim-easymotion
git clone --depth 1 https://github.com/easymotion/vim-easymotion.git

# easymotion-chs
rm -rf vim-easymotion-chs
git clone --depth 1 https://github.com/ZSaberLv0/vim-easymotion-chs.git

# easymotion-vscode
rm -rf vim-easymotion-vscode
git clone --depth 1 https://github.com/asvetliakov/vim-easymotion.git vim-easymotion-vscode

# clever-f
rm -rf clever-f.vim
git clone --depth 1 https://github.com/rhysd/clever-f.vim.git

# vim-matchup
rm -rf vim-matchup
git clone --depth 1 https://github.com/andymass/vim-matchup.git

# vim-eunuch
rm -rf vim-eunuch
git clone --depth 1 https://github.com/tpope/vim-eunuch.git

# vim-sandwich
rm -rf vim-sandwich
git clone --depth 1 https://github.com/machakann/vim-sandwich.git

# vim-grepper
rm -rf vim-grepper
git clone --depth 1  https://github.com/mhinz/vim-grepper.git
rm -rf vim-grepper/pictures

# vim-floaterm
rm -rf vim-floaterm
git clone --depth 1 https://github.com/voldikss/vim-floaterm.git

# vim-tmux-navigator
rm -rf vim-tmux-navigator
git clone --depth 1 https://github.com/christoomey/vim-tmux-navigator.git

# lightline
rm -rf lightline.vim
git clone --depth 1 https://github.com/itchyny/lightline.vim.git

# startify
rm -rf vim-startify
git clone --depth 1 https://github.com/mhinz/vim-startify.git

# sidebar
rm -rf vim-sidebar-manager
git clone --depth 1 https://github.com/brglng/vim-sidebar-manager.git

# which-key
rm -rf which-key.nvim 
git clone --depth 1 https://github.com/folke/which-key.nvim.git  
rm -rf vim-which-key
git clone --depth 1 --single-branch --branch meta_key https://github.com/leoatchina/vim-which-key.git

# asyncrun
rm -rf asyncrun.vim
git clone --depth 1 https://github.com/skywind3000/asyncrun.vim.git

# asynctasks.vim
rm -rf asynctasks.vim
git clone --depth 1 https://github.com/skywind3000/asynctasks.vim.git

# vim-repl
rm -rf vim-repl
git clone --depth 1 https://github.com/leoatchina/vim-repl.git

# iron.nvim
rm -rf iron.nvim
git clone --depth 1 https://github.com/leoatchina/iron.nvim.git

# delete files and dirs
find . -type f | grep -i \.gitignore$ | xargs rm -f
find . -type f | grep -i \.jpg$       | xargs rm -f
find . -type f | grep -i \.png$       | xargs rm -f
find . -type f | grep -i \.gif$       | xargs rm -f
find . -type f | grep -i \.bmp$       | xargs rm -f

find . -type d | grep -i \.github$ | xargs rm -rf
find . -type d | grep -i \.git$    | xargs rm -rf
find . -type d | grep -i test$     | xargs rm -rf
