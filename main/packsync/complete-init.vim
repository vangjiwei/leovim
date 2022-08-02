" --------------------------
" complete shortcuts
" --------------------------
try
    set completeopt=menuone,noselect,noinsert
catch
    try
        set completeopt=menuone
        let g:complete_engine = 'mcm'
    catch
        let g:complete_engine = 'non'
    endtry
endtry
if exists('+completepopup') != 0
    set completeopt+=popup
    set completepopup=align:menu,border:off,highlight:WildMenu
endif
" --------------------------
" complete engine
" ------------------------------
if Require('non') || CYGWIN()
    let g:complete_engine = "non"
elseif Require('mcm') || get(g:, 'complete_engine', '') == 'mcm'
    let g:complete_engine = "mcm"
elseif Require('apc') && &completeopt =~ 'noselect'
    let g:complete_engine = "apc"
elseif Require('cmp')
    if has('nvim-0.7')
        let g:complete_engine = 'cmp'
    else
        let s:smart_engine_select = 1
    endif
elseif Require('coc')
    if get(g:, 'node_version', '') != '' && (has('nvim-0.6.0') || has('patch-8.2.3389'))
        let g:complete_engine = 'coc'
    else
        let s:smart_engine_select = 1
    endif
else
    let s:smart_engine_select = 1
endif
if get(s:, 'smart_engine_select', 0)
    if get(g:, 'node_version', '') != '' && (has('nvim-0.6.0') || has('patch-8.2.3389'))
        let g:complete_engine = 'coc'
    else
        let g:complete_engine = 'mcm'
    endif
endif
if index(['coc', 'cmp'], get(g:, 'complete_engine', '')) >= 0
    let g:advanced_complete_engine = 1
else
    let g:advanced_complete_engine = 0
endif
