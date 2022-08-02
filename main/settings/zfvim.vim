if Installed('ZFVimIM')
    let g:ZFVimIM_cachePath=$HOME.'/.leovim.d/ZFVimIM'
    let g:ZFVimIM_keymap = 0
    inoremap <expr>;;    ZFVimIME_keymap_toggle_i()
    inoremap <expr><M-z> ZFVimIME_keymap_next_i()
    " call ZFVimIM_dbInit({
    "     \ 'name': 'wubi',
    "     \ 'priority': 1
    " })
    " call ZFVimIM_dbInit({
    "     \ 'name': 'pinyin',
    "     \ 'priority': 2
    " })
    augroup ZFVIM
        autocmd!
        autocmd FileType * if ZFVimIME_started() | setlocal omnifunc= | endif
    augroup END
endif
