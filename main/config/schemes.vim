syntax on
syntax enable
filetype on
filetype plugin on
set background=dark
" --------------------------
" setscheme function
" --------------------------
function! SetScheme(scheme, ...) abort
    let scheme = a:scheme
    let defaultscheme = get(a:, 1, 'hybrid')
    try
        if get(g:, 'has_truecolor', 0) > 0
            let s:tried_true_color = 1
            execute('colorscheme '. scheme)
        else
            execute('colorscheme '. defaultscheme)
        endif
    catch
        try
            execute('colorscheme '. defaultscheme)
        catch
            colorscheme hybrid
        endtry
    endtry
endfunction
" --------------------------
" schemes need truecolor
" --------------------------
if Require('gruvbox')
    call SetScheme('gruvbox-material', 'grubox')
elseif Require('edge')
    call SetScheme('edge', 'one')
elseif Require('sonokai')
    call SetScheme('sonokai', 'sublime')
elseif Require('everforest')
    call SetScheme('everforest', 'deus')
elseif Require('carbonfox')
    call SetScheme('carbonfox', 'codedark')
elseif Require('dawnfox')
    call SetScheme('dawnfox', 'codedark')
elseif Require('dayfox')
    call SetScheme('dayfox', 'codedark')
elseif Require('duskfox')
    call SetScheme('duskfox', 'codedark')
elseif Require('nightfox')
    call SetScheme('nightfox', 'codedark')
elseif Require('nordfox')
    call SetScheme('nordfox', 'codedark')
elseif Require('terafox')
    call SetScheme('terafox', 'codedark')
" --------------------------
" schemes auto selected
" --------------------------
elseif g:complete_engine == 'coc'
    if has('nvim')
        call SetScheme('gruvbox-material', 'gruvbox')
    else
        call SetScheme('everforest', 'deus')
    endif
elseif g:complete_engine == 'cmp'
    call SetScheme('nightfox', 'codedark')
elseif g:complete_engine == 'mcm'
    call SetScheme('sonokai', 'sublime')
elseif g:complete_engine == 'apc'
    call SetScheme('edge', 'one')
else
    colorscheme space-vim-dark
endif
" nvim-treesitter
if Installed('nvim-treesitter', 'nvim-treehopper')
    " parser_install_dir
    if WINDOWS()
        let g:parser_install_dir = $NVIM_DATA_PATH . "\\tree-sitter"
    else
        let g:parser_install_dir = $NVIM_DATA_PATH . "/tree-sitter"
    endif
    silent! call mkdir(g:parser_install_dir . "/parser", "p")
    exec "set rtp+=" . g:parser_install_dir
    " map and config
    luafile $LUA_PATH/treesitter.lua
endif
