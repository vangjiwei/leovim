if Installed('ZFVimIM')
    let g:ZFVimIM_cachePath=$HOME.'/.leovim.d/ZFVimIM'
    let g:ZFVimIM_key_pageUp = ['-']
    let g:ZFVimIM_key_pageDown = ['=']
    let g:ZFVimIM_key_chooseL = ['[']
    let g:ZFVimIM_key_chooseR = [']']
    augroup ZFVIM
        autocmd!
        autocmd FileType * if ZFVimIME_started() | setlocal omnifunc= | endif
    augroup END
    function! ZFVimIMELoop(type)
        if Installed('ZFVimIM_wubi_base') && a:type > 0
            if ZFVimIME_IMEName() == 'wubi'
                call ZFVimIME_keymap_next_n()
            elseif ZFVimIME_IMEName() == 'pinyin'
                call ZFVimIME_keymap_next_n()
                call ZFVimIME_keymap_toggle_n()
            else
                call ZFVimIME_keymap_toggle_n()
            endif
        else
            call ZFVimIME_keymap_toggle_n()
        endif
        let ime_name = ZFVimIME_IMEName()
        if ime_name == ''
            echo "english input"
        else
            echo ime_name . " input"
        end
    endfunction

    if Require('wubi')
        function! s:myLocalDb()
            let wubi = ZFVimIM_dbInit(
                        \ {
                            \ 'name':'wubi',
                            \ 'priority':1
                            \ }
                        \ )
            let pinyin = ZFVimIM_dbInit(
                        \ {
                            \ 'name':'pinyin',
                            \ 'priority':2
                            \ }
                        \ )
            autocmd User ZFVimIM_event_OnDbInit call s:myLocalDb()
        endfunction
    endif
    " keymap
    let g:ZFVimIM_keymap = 0
    nnoremap <silent><M-Z>      :call ZFVimIMELoop(1)<Cr>
    inoremap <silent><M-Z> <C-o>:call ZFVimIMELoop(1)<Cr>
    nnoremap <silent><M-z>        :call ZFVimIMELoop(0)<Cr>
    inoremap <expr><silent> ;;    ZFVimIME_keymap_toggle_i()
    inoremap <expr><silent> <M-z> ZFVimIME_keymap_toggle_i()
    " input in commandline
    function! ZF_Setting_cmdEdit()
        let cmdtype = getcmdtype()
        if cmdtype != ':' && cmdtype != '/'
            return ''
        endif
        call feedkeys("\<c-c>q" . cmdtype . 'k0' . (getcmdpos() - 1) . 'li', 'nt')
        return ''
    endfunction
    cnoremap <silent><expr> :: ZF_Setting_cmdEdit()
    " input in terminal
    if has('terminal') || has('nvim')
        function! PassToTerm(text)
            let @t = a:text
            if has('nvim')
                call feedkeys('"tpa', 'nt')
            else
                call feedkeys("a\<c-w>\"t", 'nt')
            endif
            redraw!
        endfunction
        command! -nargs=* PassToTerm :call PassToTerm(<q-args>)
        tnoremap :: <c-\><c-n>q:a:PassToTerm<space>
    endif
else
    nnoremap <M-z> <Nop>
    nnoremap <M-Z> <Nop>
endif
