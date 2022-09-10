if Installed('ZFVimIM')
    let g:ZFVimIM_cachePath=$HOME.'/.leovim.d/ZFVimIM'
    let g:ZFVimIM_keymap = 0
    let g:ZFVimIM_key_pageUp = ['-']
    let g:ZFVimIM_key_pageDown = ['=']
    let g:ZFVimIM_key_chooseL = ['[']
    let g:ZFVimIM_key_chooseR = [']']
    augroup ZFVIM
        autocmd!
        autocmd FileType * if ZFVimIME_started() | setlocal omnifunc= | endif
    augroup END
    function! ZFVimIMELoop()
        if ZFVimIME_IMEName() == ''
            call ZFVimIME_keymap_toggle_n()
        elseif Installed('ZFVimIM_wubi_base')
            if ZFVimIME_IMEName() == 'wubi'
                call ZFVimIME_keymap_next_n()
            else
                call ZFVimIME_keymap_next_n()
                call ZFVimIME_keymap_toggle_n()
            endif
        else
            call ZFVimIME_keymap_toggle_n()
        endif
        let l:ime_name = ZFVimIME_IMEName()
        if l:ime_name == ''
            echo "nochs input"
        else
            echo l:ime_name . " input"
        end
    endfunction
    imap <M-z> <C-o>:call ZFVimIMELoop()<Cr>
    nmap <M-z>      :call ZFVimIMELoop()<Cr>
endif
