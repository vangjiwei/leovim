" ------------------------------
"  symbol_tool
" ------------------------------
if exists('g:symbol_tool')
    unlet g:symbol_tool
endif
let g:symbol_tool = []
function! RequireSymbol(plug) abort
    return count(g:symbol_tool, a:plug)
endfunction
function! PackSymbol(plug) abort
    if RequireSymbol(a:plug) <= 0
        let g:symbol_tool += [a:plug]
    endif
endfunction
" ------------------------------
" ctags
" ------------------------------
if get(g:, 'ctags_type', '') != ''
    if Planned('leaderf')
        call PackSymbol("leaderfctags")
    else
        call PackSymbol("fzfctags")
    endif
    if Planned('vim-quickui')
        call PackSymbol('quickui')
    endif
endif
" ------------------------------
" lsp or vista
" ------------------------------
if g:complete_engine == 'cmp'
    call PackSymbol('lsp')
    call PackSymbol('telescope')
    PackAdd 'glepnir/lspsaga.nvim'
      \| PackAdd 'gbrlsnchs/telescope-lsp-handlers.nvim'
elseif g:complete_engine == 'coc'
    call PackSymbol('coc')
    call PackSymbol('vista')
elseif v:version >= 800 && get(g:, 'ctags_type', '') =~ 'Universal'
    call PackSymbol('vista')
elseif get(g:, 'ctags_type', '') != ''
    call PackSymbol('tagbar')
endif
" ------------------------------
" gutentags
" ------------------------------
if v:version >= 800 && get(g:, 'ctags_type', '') != ''
    call PackSymbol("gutentags")
endif
" ------------------------------
" gtags
" ------------------------------
if WINDOWS()
    let g:Lf_Gtagsconf = get(g:, 'Lf_Gtagsconf', expand($HOME . "/.leovim.d/windows/gtags/share/gtags/gtags.conf"))
endif
if executable('gtags-cscope') && executable('gtags') && filereadable(get(g:, 'Lf_Gtagsconf', '')) && RequireSymbol('gutentags')
    let s:gtags_version = matchstr(system('gtags --version'), '\v\zs\d{1,2}.\d{1,2}.\d{1,2}\ze')
    let g:gtags_version = StringToFloat(s:gtags_version)
    if g:gtags_version >= 6.67
        call PackSymbol('plus')
        if Planned('leaderf') && g:python_version > 3
            call PackSymbol('leaderfgtags')
        endif
    else
        echom "gtags 6.67+ is required"
    endif
endif
" ------------------------------
" install
" ------------------------------
if RequireSymbol('gutentags')
    PackAdd 'skywind3000/vim-gutentags'
endif
if RequireSymbol('plus')
    PackAdd 'skywind3000/gutentags_plus'
endif
if RequireSymbol('vista')
    PackAdd 'liuchengxu/vista.vim'
elseif RequireSymbol('tagbar')
    PackAdd 'preservim/tagbar'
endif
