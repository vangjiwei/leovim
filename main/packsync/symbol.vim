" ------------------------------
"  symbol_group
" ------------------------------
let g:symbol_group = []
function! SymbolPlanned(plug) abort
    return count(g:symbol_group, a:plug)
endfunction
function! SymbolRequire(plug) abort
    if SymbolPlanned(a:plug) <= 0
        let g:symbol_group += [a:plug]
    endif
endfunction
" ------------------------------
" sidebar symbols
" ------------------------------
if g:complete_engine == 'cmp'
    PackAdd 'glepnir/lspsaga.nvim'
      \| PackAdd 'gbrlsnchs/telescope-lsp-handlers.nvim'
else
    if get(g:, 'ctags_type', '') != ''
        if Planned('leaderf')
            call SymbolRequire("leaderfctags")
        else
            call SymbolRequire("fzfctags")
        endif
    endif
    if (g:complete_engine == 'coc' || get(g:, 'ctags_type', '') =~ 'Universal' && Require('vista')) && v:version >= 800
        call SymbolRequire('vista')
    endif
endif
" ------------------------------
" gutentags
" ------------------------------
if v:version >= 800
    if get(g:, 'ctags_type', '') != ''
        if Planned('vim-quickui')
            call SymbolRequire('quickui')
        endif
        call SymbolRequire("gutentags")
    endif
endif
" ------------------------------
" gtags
" ------------------------------
if WINDOWS()
    let $GTAGSCONF = expand($HOME . "/.leovim.d/windows/gtags/share/gtags/gtags.conf")
endif
if executable('gtags-cscope') && executable('gtags') && exists("$GTAGSCONF") && filereadable($GTAGSCONF) && SymbolPlanned('gutentags')
    let s:gtags_version = matchstr(system('gtags --version'), '\v\zs\d{1,2}.\d{1,2}.\d{1,2}\ze')
    let g:gtags_version = StringToFloat(s:gtags_version)
    if g:gtags_version >= 6.67
        call SymbolRequire('plus')
        if Planned('leaderf')
            call SymbolRequire('leaderfgtags')
        endif
    else
        echom "gtags 6.67+ is required"
    endif
endif
" ------------------------------
" install
" ------------------------------
if SymbolPlanned('gutentags')
    PackAdd 'skywind3000/vim-gutentags'
endif
if SymbolPlanned('plus')
    PackAdd 'skywind3000/gutentags_plus'
endif
if SymbolPlanned('vista')
    PackAdd 'liuchengxu/vista.vim'
endif
