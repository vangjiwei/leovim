" ------------------------
" remap
" ------------------------
map ÏP <F1>
map ÏQ <F2>
map ÏR <F3>
map ÏS <F4>
map <F1>  <Nop>
map <F2>  <Nop>
map <F3>  <Nop>
map <F4>  <Nop>
map <F5>  <Nop>
map <F6>  <Nop>
map <F7>  <Nop>
map <F8>  <Nop>
map <F9>  <Nop>
map <F10> <Nop>
map <F11> <Nop>
map <F12> <Nop>
map <M-B> <Nop>
map <M-O> <Nop>
map <C-n> <Nop>
map <C-q> <Nop>
map <C-s> <Nop>
map <C-i> <Nop>
map <C-z> <Nop>
nmap S    <Nop>
nmap <C-j> %
nmap <C-k> g%
xmap <C-j> %
xmap <C-k> g%
nmap <BS> <C-h>
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
" basic tetxobj
" --------------------------
nnoremap <leader>vp viwp
nnoremap <leader>v' vi'
nnoremap <leader>v" vi"
nnoremap <leader>v( va)
nnoremap <leader>v) vi)
nnoremap <leader>v[ va]
nnoremap <leader>v] vi]
nnoremap <leader>v{ va}
nnoremap <leader>v} vi}
nnoremap <leader>v< va>
nnoremap <leader>v> vi>
nnoremap <leader>c' ci'
nnoremap <leader>c" ci"
nnoremap <leader>c( ca)
nnoremap <leader>c) ci)
nnoremap <leader>c[ ca]
nnoremap <leader>c] ci]
nnoremap <leader>c{ ca}
nnoremap <leader>c} ci}
nnoremap <leader>c< ca>
nnoremap <leader>c> ci>
nnoremap <leader>d' di'
nnoremap <leader>d" di"
nnoremap <leader>d( da)
nnoremap <leader>d) di)
nnoremap <leader>d[ da]
nnoremap <leader>d] di]
nnoremap <leader>d{ da}
nnoremap <leader>d} di}
nnoremap <leader>d< da>
nnoremap <leader>d> di>
nnoremap <leader>y' yi'
nnoremap <leader>y" yi"
nnoremap <leader>y( ya)
nnoremap <leader>y) yi)
nnoremap <leader>y[ ya]
nnoremap <leader>y] yi]
nnoremap <leader>y{ ya}
nnoremap <leader>y} yi}
nnoremap <leader>y< ya>
nnoremap <leader>y> yi>
" ------------------------
" some enhanced shortcuts
" ------------------------
nmap gb 2g;a
nmap !  :!
xmap !  :<C-u>!<C-R>=GetVisualSelection()<Cr>
xmap .  :<C-u>normal .<Cr>
xmap /  y/<C-R>"
xmap ?  y?<C-R>"
" ------------------------
" yank
" ------------------------
if exists("##TextYankPost") && UNIX() && exists('*trim')
    function! s:raw_echo(str)
        if filewritable('/dev/fd/2')
            call writefile([a:str], '/dev/fd/2', 'b')
        else
            exec("silent! !echo " . shellescape(a:str))
            redraw!
        endif
    endfunction
    function! s:copy() abort
        let c = join(v:event.regcontents,"\n")
        if len(trim(c)) == 0
            return
        endif
        let c64 = system("base64", c)
        if $TMUX == ''
            let s = "\e]52;c;" . trim(c64) . "\x07"
        else
            let s = "\ePtmux;\e\e]52;c;" . trim(c64) . "\x07\e\\"
        endif
        call s:raw_echo(s)
    endfunction
    autocmd TextYankPost * call s:copy()
endif
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
xnoremap zp "_c<ESC>p"
xnoremap zP "_c<ESC>P"
" Yank a line without leading whitespaces and line break
nnoremap <leader>yu mp_yg_`p
" Copy a line without leading whitespaces and line break to clipboard
nnoremap <leader>yw mp_"+yg_`P
" Copy file path
nnoremap <leader>yp :let @*=expand("%:p")<cr>:echo '-= File path copied=-'<Cr>
" Copy file name
nnoremap <leader>yf :let @*=expand("%:t")<cr>:echo '-= File name copied=-'<Cr>
" Copy bookmark position reference
nnoremap <leader>yb :let @*=expand("%:p").':'.line(".").':'.col(".")<cr>:echo '-= Cursor bookmark copied=-'<cr>'
" --------------------------
" StripTrailingWhiteSpace
" --------------------------
augroup TrailSpace
    autocmd FileType vim,c,cpp,java,go,php,javascript,typescript,python,rust,twig,xml,yml,perl,sql,r,conf,lua
        \ autocmd! BufWritePre <buffer> :call TripTrailingWhiteSpace()
augroup END
command! TripTrailingWhiteSpace call TripTrailingWhiteSpace()
nnoremap d<space> :TripTrailingWhiteSpace<Cr>
