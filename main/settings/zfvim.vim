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
    " map
    imap <expr><M-z> ZFVimIME_keymap_toggle_i()
    nmap <M-z>      :call ZFVimIME_keymap_toggle_n() \| echo g:ZFVimIME_IMEName()<Cr>
    imap <M-m> <C-o>:call ZFVimIME_keymap_next_n() \| echo g:ZFVimIME_IMEName()<Cr>
    nmap <M-m><M-m> :call ZFVimIME_keymap_next_n() \| echo g:ZFVimIME_IMEName()<Cr>
endif
