" -----------------------
" APC settings
" -----------------------
let g:apc_min_length = get(g:, 'apc_min_length', 2)
let g:apc_key_ignore = get(g:, 'apc_key_ignore', [])
let g:apc_enable_tab = !Installed('ultisnips') && !Installed('vim-vsnip')
let g:apc_enable_ft  = {'*':1}
set cpt=.,s,d,t,k,w,b
" get word before cursor
function! s:get_context()
    return strpart(getline('.'), 0, col('.') - 1)
endfunc
function! s:meets_keyword(context)
    if g:apc_min_length <= 0
        return 0
    endif
    let matches = matchlist(a:context, '\(\k\{' . g:apc_min_length . ',}\)$')
    if empty(matches)
        return 0
    endif
    for ignore in g:apc_key_ignore
        if stridx(ignore, matches[1]) == 0
            return 0
        endif
    endfor
    return 1
endfunc
function! s:on_backspace()
    if pumvisible() == 0
        return "\<BS>"
    endif
    let text = matchstr(s:get_context(), '.*\ze.')
    return s:meets_keyword(text)? "\<BS>" : "\<c-e>\<bs>"
endfunc
" autocmd for CursorMovedI
function! s:feed_popup()
    let enable = get(b:, 'apc_enable', 0)
    let lastx  = get(b:, 'apc_lastx', -1)
    let lasty  = get(b:, 'apc_lasty', -1)
    let tick   = get(b:, 'apc_tick', -1)
    if &bt != '' || enable == 0 || &paste
        return -1
    endif
    let x = col('.') - 1
    let y = line('.') - 1
    if pumvisible()
        let context = s:get_context()
        if s:meets_keyword(context) == 0
            call feedkeys("\<c-e>", 'n')
        endif
        let b:apc_lastx = x
        let b:apc_lasty = y
        let b:apc_tick  = b:changedtick
        return 0
    elseif lastx == x && lasty == y
        return -2
    elseif b:changedtick == tick
        let lastx = x
        let lasty = y
        return -3
    endif
    let context = s:get_context()
    if s:meets_keyword(context)
        silent! call feedkeys("\<c-n>", 'n')
        let b:apc_lastx = x
        let b:apc_lasty = y
        let b:apc_tick  = b:changedtick
    endif
    return 0
endfunc
" autocmd for CompleteDone
function! s:complete_done()
    let b:apc_lastx = col('.') - 1
    let b:apc_lasty = line('.') - 1
    let b:apc_tick  = b:changedtick
endfunc
" enable apc
function! s:apc_enable()
    call s:apc_disable()
    augroup ApcEventGroup
        au!
        au CursorMovedI <buffer> nested call s:feed_popup()
        au CompleteDone <buffer> call s:complete_done()
    augroup END
    let b:apc_init_autocmd = 1
    if g:apc_enable_tab > 0
        let b:apc_init_tab = 1
        inoremap <silent><buffer><expr> <tab>
                    \ pumvisible()? "\<c-y>" :
                    \ Has_Back_Space() ? "\<tab>" : "\<c-n>"
        inoremap <silent><buffer><expr> <s-tab>
                    \ pumvisible()? "\<c-p>" : "\<C-h>"
    endif
    inoremap <silent><buffer><expr> <bs> <SID>on_backspace()
    let b:apc_init_bs = 1
    let b:apc_init_cr = 1
    let b:apc_save_infer = &infercase
    setlocal infercase
    let b:apc_enable = 1
endfunc
" disable apc
function! s:apc_disable()
    if get(b:, 'apc_init_autocmd', 0)
        augroup ApcEventGroup
            au!
        augroup END
    endif
    if get(b:, 'apc_init_tab', 0)
        silent! iunmap <buffer><expr> <tab>
        silent! iunmap <buffer><expr> <s-tab>
    endif
    if get(b:, 'apc_init_bs', 0)
        silent! iunmap <buffer><expr> <bs>
    endif
    if get(b:, 'apc_init_cr', 0)
        silent! iunmap <buffer><expr> <cr>
    endif
    if get(b:, 'apc_save_infer', '') != ''
        let &l:infercase = b:apc_save_infer
    endif
    let b:apc_init_autocmd = 0
    let b:apc_init_tab = 0
    let b:apc_init_bs = 0
    let b:apc_init_cr = 0
    let b:apc_save_infer = ''
    let b:apc_enable = 0
endfunc
" check if need to be enabled
function! s:apc_check_init()
    if &bt == '' && get(g:apc_enable_ft, &ft, 0) != 0
        ApcEnable
    elseif &bt == '' && get(g:apc_enable_ft, '*', 0) != 0
        ApcEnable
    endif
endfunc
" commands & autocmd
command! -nargs=0 ApcEnable call s:apc_enable()
command! -nargs=0 ApcDisable call s:apc_disable()
augroup ApcInitGroup
    au!
    au FileType * call s:apc_check_init()
    au BufEnter * call s:apc_check_init()
    au TabEnter * call s:apc_check_init()
augroup END
