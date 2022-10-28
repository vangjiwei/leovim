" --------------------------
" Important plugins
" --------------------------
"  NOTE: finder shuould be installed before complete_lint
source $PACKSYNC_PATH/finder.vim
if get(g:, "complete_engine", '') != ''
    source $PACKSYNC_PATH/program.vim
    source $PACKSYNC_PATH/languages.vim
endif
source $PACKSYNC_PATH/tag.vim
source $PACKSYNC_PATH/debug.vim
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
    nnoremap <leader>A :AddHeader<Cr>
endif
" ------------------------------
" git
" ------------------------------
if executable('git') && v:version >= 800 && g:git_version >= 1.85
    PackAdd 'tpope/vim-fugitive' | PackAdd 'rbong/vim-flog'
    if g:has_popup_float
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
    if executable('go') && UNIX() && v:version >= 800
        PackAdd 'RRethy/vim-hexokinase', {'for': ['css', 'html', 'less', 'scss', 'sass', 'stylus', 'vim'], 'do': 'make hexokinase'}
        let g:Hexokinase_highlighters  = ['backgroundfull']
        nnoremap <M-k>o :HexokinaseToggle<Cr>
    else
        PackAdd 'gorodinskiy/vim-coloresque', {'for': ['css', 'html', 'less', 'scss', 'sass', 'stylus']}
    endif
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
elseif g:complete_engine != 'coc' && v:version >= 800
    PackAdd 'tmsvg/pear-tree'
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
" fold
" ------------------------------
if has('nvim') && UNIX()
    PackAdd 'kevinhwang91/promise-async' | PackAdd 'kevinhwang91/nvim-ufo'
endif
" ------------------------------
" zfvim
" ------------------------------
" zfvimdirdiff
PackAdd 'ZSaberLv0/ZFVimDirDiff'
PackAdd 'ZSaberLv0/ZFVimIgnore'
PackAdd 'ZSaberLv0/ZFVimJob'
" zfvimim
if (Require('wubi') || Require('pinyin')) && g:has_terminal
    PackAdd 'ZSaberLv0/ZFVimIM', {'opt': 0}
    if Require('wubi')
        PackAdd 'ZSaberLv0/ZFVimIM_wubi_base'
        let g:input_method = 'zfvim_wubi'
    else
        let g:input_method = 'zfvim_pinyin'
    endif
    PackAdd 'ZSaberLv0/ZFVimIM_pinyin'
endif
" ------------------------------
" schemes
" ------------------------------
source $PACKSYNC_PATH/schemes-textobj.vim
