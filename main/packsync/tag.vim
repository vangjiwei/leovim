" ------------------------------
"  symbol_tool
" ------------------------------
let g:symbol_tool = []
function! SymbolPlanned(plug) abort
    return count(g:symbol_tool, a:plug)
endfunction
function! SymbolRequire(plug) abort
    if SymbolPlanned(a:plug) <= 0
        let g:symbol_tool += [a:plug]
    endif
endfunction
" ------------------------------
" ctags
" ------------------------------
if get(g:, 'ctags_type', '') != ''
    if Planned('leaderf')
        call SymbolRequire("leaderfctags")
    else
        call SymbolRequire("fzfctags")
    endif
    if Planned('vim-quickui')
        call SymbolRequire('quickui')
    endif
endif
" ------------------------------
" lsp or vista
" ------------------------------
if g:complete_engine == 'cmp'
    call SymbolRequire('lsp')
    call SymbolRequire('telescope')
    PackAdd 'glepnir/lspsaga.nvim'
      \| PackAdd 'gbrlsnchs/telescope-lsp-handlers.nvim'
elseif g:complete_engine == 'coc'
    call SymbolRequire('coc')
    call SymbolRequire('vista')
elseif v:version >= 800 && get(g:, 'ctags_type', '') != ''
    call SymbolRequire('vista')
endif
" ------------------------------
" gutentags
" ------------------------------
if v:version >= 800 && get(g:, 'ctags_type', '') != ''
    call SymbolRequire("gutentags")
endif
" ------------------------------
" gtags
" ------------------------------
if WINDOWS()
    let g:Lf_Gtagsconf = get(g:, 'Lf_Gtagsconf', expand($HOME . "/.leovim.d/windows/gtags/share/gtags/gtags.conf"))
endif
if executable('gtags-cscope') && executable('gtags') && filereadable(get(g:, 'Lf_Gtagsconf', '')) && SymbolPlanned('gutentags')
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
