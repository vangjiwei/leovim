" ------------------------
" core remap
" ------------------------
xmap     >>       >gv
xmap     <<       <gv
nnoremap <silent> gj j
nnoremap <silent> gk k
nnoremap <silent> j gj
nnoremap <silent> k gk
" home end
nnoremap H ^
xnoremap H ^
onoremap H ^
nnoremap L g_
xnoremap L g_
onoremap L g_
" z remap
nnoremap zs <Nop>
nnoremap zS <Nop>
nnoremap zw <Nop>
nnoremap zW <Nop>
nnoremap zg <Nop>
nnoremap zG <Nop>
nnoremap zl zL
nnoremap zh zH
nnoremap zr zR
nnoremap z= zT
nnoremap z- zB
nnoremap ZT zt
nnoremap zt z<CR>
" --------------------------
" basic yank paste
" --------------------------
nnoremap vp vawp
nnoremap vw viw
nnoremap vW vaw
nnoremap v' vi'
nnoremap v" vi"
nnoremap v( va)
nnoremap v) vi)
nnoremap v[ va]
nnoremap v] vi]
nnoremap v{ va}
nnoremap v} vi}
nnoremap cw ciw
nnoremap cW caW
nnoremap c' ci'
nnoremap c" ci"
nnoremap c( ca)
nnoremap c) ci)
nnoremap c[ ca]
nnoremap c] ci]
nnoremap c{ ca}
nnoremap c} ci}
nnoremap dw diw
nnoremap dW daw
nnoremap d' di'
nnoremap d" di"
nnoremap d( da)
nnoremap d) di)
nnoremap d[ da]
nnoremap d] di]
nnoremap d{ da}
nnoremap d} di}
nnoremap yw yiw
nnoremap yW yaw
nnoremap y' yi'
nnoremap y" yi"
nnoremap y( ya)
nnoremap y) yi)
nnoremap y[ ya]
nnoremap y] yi]
nnoremap y{ ya}
nnoremap y} yi}
" ----------------------
" yank
" ---------------------
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
if !exist('g:vscode')
    " Yank a line without leading whitespaces and line break
    nnoremap <leader>yu mp_yg_`p
    " Copy a line without leading whitespaces and line break to clipboard
    nnoremap <leader>yw mp_"+yg_`P
    " Copy file path
    nnoremap <leader>yp :let @*=expand("%:p")<cr>:echo '-= File path copied=-'<Cr>
    " Copy file name
    nnoremap <leader>yf :let @*=expand("%:t")<cr>:echo '-= File name copied=-'<Cr>
    " Copy bookmark position reference
    nnoremap <leader>yb :let @*=expand("%:p").':'.line(".").':'.col(".")<cr>:echo '-= Cursor bookmark  copied=-'<cr>'
endif
xnoremap zp "_c<ESC>p"
xnoremap zP "_c<ESC>P"
