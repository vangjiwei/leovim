" c-v as prefix
tmap <C-v> <C-\><C-n>
" --------------------------
" set termwinkey
" --------------------------
tnoremap <expr> <C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
tnoremap <M-q> <C-\><C-n>:q!<CR>
tnoremap <M-w> <C-\><C-n>:ChooseWin<CR>
tnoremap <C-g> <C-\><C-n>
" tab control
tnoremap <silent> <M-1>  <C-\><C-n>:tabn1<Cr>
tnoremap <silent> <M-2>  <C-\><C-n>:tabn2<Cr>
tnoremap <silent> <M-3>  <C-\><C-n>:tabn3<Cr>
tnoremap <silent> <M-4>  <C-\><C-n>:tabn4<Cr>
tnoremap <silent> <M-5>  <C-\><C-n>:tabn5<Cr>
tnoremap <silent> <M-6>  <C-\><C-n>:tabn6<Cr>
tnoremap <silent> <M-7>  <C-\><C-n>:tabn7<Cr>
tnoremap <silent> <M-8>  <C-\><C-n>:tabn8<Cr>
tnoremap <silent> <M-9>  <C-\><C-n>:tabn9<Cr>
tnoremap <silent> <M-0>  <C-\><C-n>:tablast<Cr>
" --------------------------
" cannot paste in floaterm when using vim9.0
" --------------------------
if g:has_terminal == 1
    tnoremap <M-'> <C-\><C-n>""pa
else
    tnoremap <M-'> <C-_>""
endif
if has('clipboard')
    if g:has_terminal == 1
        tnoremap <M-v> <C-\><C-n>"*pa
    else
        tnoremap <M-v> <C-_>"*
    endif
else
    if g:has_terminal == 1
        tnoremap <M-v> <C-\><C-n>""pa
    else
        tnoremap <M-v> <C-_>""
    endif
endif
" --------------------------
" open terminal
" --------------------------
if has('nvim')
    if WINDOWS()
        nnoremap <Tab>t :tabe term://cmd<cr>i
    else
        nnoremap <Tab>t :tabe term://bash<cr>i
    endif
else
    nnoremap <Tab>t :tab terminal<Cr>
endif
" --------------------------
" floaterm
" --------------------------
if get(g:, 'terminal_plus', '') == ''
    let g:terminal_plus = 'floaterm'
endif
let g:floaterm_open_command = 'drop'
let g:floaterm_wintype  = 'split'
let g:floaterm_position = 'botright'
let g:floaterm_height   = get(g:, 'asyncrun_open', 10)
let g:floaterm_keymap_new  = '<Nop>'
let g:floaterm_keymap_prev = '<M-{>'
let g:floaterm_keymap_next = '<M-}>'
" toggle
nnoremap <silent><M--> :FloatermToggle<Cr>
tnoremap <silent><M--> <C-\><C-n>:FloatermToggle<Cr>
nnoremap <silent><M-=> :FloatermNew<Cr>
tnoremap <silent><M-=> <C-\><C-n>:FloatermKill<Cr>
if has("popupwin") && !MACOS() || exists('*nvim_open_win')
    nnoremap <silent><Tab>c :FloatermNew --wintype=float --height=0.80 --width=0.80 --position=center<Cr>
    nnoremap <silent><Tab>w :FloatermNew --wintype=float --height=0.65 --width=0.45 --position=topright<Cr>
endif
" key map
nnoremap <Tab>f :Floaterm
nnoremap <Tab>! :FloatermKill<Space>
nnoremap <Tab>+ :FloatermNew<Space>
tnoremap <silent><M-}> <C-\><C-n>:FloatermNext<Cr>
tnoremap <silent><M-{> <C-\><C-n>:FloatermPrev<Cr>
nnoremap <silent><Tab>1 :FloatermFirst<Cr>
nnoremap <silent><Tab>0 :FloatermLast<Cr>
PackAdd 'vim-floaterm'
