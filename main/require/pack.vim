" ------------------------------
" zfvim
" ------------------------------
" zfvimim
if (Require('wubi') || Require('pinyin')) && g:has_terminal > 0
    PackAdd 'ZSaberLv0/ZFVimIM', {'merged': 0}
    if Require('wubi')
        PackAdd 'ZSaberLv0/ZFVimIM_wubi_base'
        let g:input_method = 'zfvim_wubi'
    else
        let g:input_method = 'zfvim_pinyin'
    endif
    PackAdd 'ZSaberLv0/ZFVimIM_pinyin'
endif
PackAdd 'ZSaberLv0/ZFVimJob'
PackAdd 'ZSaberLv0/ZFVimIgnore'
PackAdd 'ZSaberLv0/ZFVimDirDiff'
" --------------------------
" Important plugins
" --------------------------
"  NOTE: assist shuould be installed before complete_lint
source $REQUIRE_PATH/assist.vim
if get(g:, "complete_engine", '') != ''
    source $REQUIRE_PATH/program.vim
    source $REQUIRE_PATH/languages.vim
endif
source $REQUIRE_PATH/tag.vim
" ------------------------------
" fullscreen
" ------------------------------
if LINUX() && g:gui_running == 1 && executable('wmctrl')
    PackAdd 'lambdalisue/vim-fullscreen'
    if has('nvim')
        let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
        let g:fullscreen#stop_command  = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"
    endif
endif
" ------------------------------
" vim-header
" ------------------------------
if get(g:, 'header_field_author', '') != ''
    PackAdd 'alpertuna/vim-header'
    let g:header_auto_add_header = 0
    let g:header_auto_update_header = 0
    let g:header_field_timestamp_format = '%Y.%m.%d'
    nnoremap <leader>ea :AddHeader<Cr>
endif
" ------------------------------
" git
" ------------------------------
if executable('git') && v:version >= 800 && g:git_version >= 1.85
    PackAdd 'tpope/vim-fugitive' | PackAdd 'rbong/vim-flog'
    if g:has_popup_floating
        PackAdd 'APZelos/blamer.nvim'
    endif
endif
" ------------------------------
" signify
" ------------------------------
if has('nvim') || has('patch-8.0.902')
    PackAdd 'mhinz/vim-signify'
endif
" ------------------------------
" tmux
" ------------------------------
if executable('tmux') && g:gui_running == 0 && (has('nvim') || has('patch-8.0.1394'))
    PackAdd 'preservim/vimux'
    PackAdd 'roxma/vim-tmux-clipboard'
    PackAdd 'tmux-plugins/vim-tmux-focus-events'
endif
" ------------------------------
" status
" ------------------------------
if has('signs')
    PackAdd 'kshenoy/vim-signature'
    PackAdd 'rhysd/conflict-marker.vim'
endif
" --------------------------
" indentline
" --------------------------
PackAdd 'Yggdroot/indentLine'
" ------------------------------
" pairs
" ------------------------------
if g:complete_engine == 'cmp'
    PackAdd 'windwp/nvim-autopairs'
elseif g:complete_engine != 'coc'
    if v:version >= 800
        PackAdd 'tmsvg/pear-tree'
    elseif has('patch-7.4.849')
        PackAdd 'jiangmiao/auto-pairs'
    endif
endif
" ------------------------------
" fold
" ------------------------------
if has('nvim') && UNIX()
    PackAdd 'kevinhwang91/promise-async' | PackAdd 'kevinhwang91/nvim-ufo'
endif
" ------------------------------
" translate && document
" ------------------------------
if Require('query') && v:version >= 800
    if g:python_version >= 3
        PackAdd 'voldikss/vim-translator'
    endif
    if MACOS()
        PackAdd 'rizzatti/dash.vim'
    elseif !CYGWIN()
        PackAdd 'KabbAmine/zeavim.vim'
    endif
endif
" ------------------------------
" schemes
" ------------------------------
source $REQUIRE_PATH/schemes-textobj.vim
