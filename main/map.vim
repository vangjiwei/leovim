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
nmap <C-j> %
nmap <C-k> g%
xmap <C-j> %
xmap <C-k> g%
nnoremap S <Nop>
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
