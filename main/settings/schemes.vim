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
    let defaultscheme = get(a:, 1, 'slate')
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
            colorscheme slate
        endtry
    endtry
endfunction
" --------------------------
" schemes need truecolor
" --------------------------
if Require('gruvbox')
    call SetScheme('gruvbox-material', 'grubox')
elseif Require('edge')
    call SetScheme('edge', 'codedark')
elseif Require('sonokai')
    call SetScheme('sonokai', 'sublime')
elseif Require('everforest')
    call SetScheme('everforest', 'deus')
" themes must be installed
elseif Require('nightfly') && Installed('vim-nightfly-guicolors')
    call SetScheme('nightfly')
elseif Require('carbonfox') && Installed('nightfox.nvim')
    call SetScheme('carbonfox')
elseif Require('dawnfox') && Installed('nightfox.nvim')
    call SetScheme('dawnfox')
elseif Require('dayfox') && Installed('nightfox.nvim')
    call SetScheme('dayfox')
elseif Require('duskfox') && Installed('nightfox.nvim')
    call SetScheme('duskfox')
elseif Require('nightfox') && Installed('nightfox.nvim')
    call SetScheme('nightfox')
elseif Require('nordfox') && Installed('nightfox.nvim')
    call SetScheme('nordfox')
elseif Require('terafox') && Installed('nightfox.nvim')
    call SetScheme('terafox')
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
    call SetScheme('sonokai', 'sublime')
elseif g:complete_engine == 'apc'
    call SetScheme('edge', 'codedark')
else
    colorscheme hybrid
endif
" nvim-treesitter
if Installed('nvim-treesitter', 'nvim-treehopper')
    " parser_install_dir
    if UNIX()
        let g:parser_install_dir = expand("~/.local/share/nvim/parsers")
    else
        let g:parser_install_dir = expand("~/AppData/Local/nvim-data/parsers")
    endif
    silent! call mkdir(g:parser_install_dir . "/parser", "p")
    exec "set rtp+=" . g:parser_install_dir
    " map and config
    nnoremap <M-l>u :TSUpdate<Space>
    nnoremap <M-l>i :TSInstall<Space>
    luafile $LUA_PATH/treesitter.lua
endif
