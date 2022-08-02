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
" additional schemes
elseif Require('moonfly') && Installed('vim-moonlfy-colors')
    call SetScheme('moonfly')
elseif Require('nightfly') && Installed('vim-nightfly-guicolors')
    call SetScheme('nightfly')
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
elseif g:complete_engine == 'mcm'
    call SetScheme('edge', 'codedark')
elseif g:complete_engine == 'apc'
    colorscheme hybrid
else
    colorscheme one
endif
" nvim-treesitter
if Installed('nvim-treesitter')
    luafile $LUA_PATH/treesitter.lua
    nnoremap <M-l>U :TSUpdate<Space>
    nnoremap <M-l>I :TSInstall<Space>
    if Installed('nvim-treesitter-context')
        hi! link TreesitterContext Visual
    endif
endif
