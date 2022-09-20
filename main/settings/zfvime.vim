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
    nnoremap <silent><M-Z>      :call ZFVimIMELoop(1)<Cr>
    inoremap <silent><M-Z> <C-o>:call ZFVimIMELoop(1)<Cr>
    nnoremap <silent><M-z>        :call ZFVimIMELoop(0)<Cr>
    inoremap <expr><silent> ;;    ZFVimIME_keymap_toggle_i()
    inoremap <expr><silent> <M-z> ZFVimIME_keymap_toggle_i()
else
    nnoremap <M-z> <Nop>
    nnoremap <M-Z> <Nop>
endif
