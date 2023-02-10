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
" XXX: cannot paste in floaterm when using vim9.0
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
" terminal-help
" --------------------------
let g:terminal_plus = 'help'
if get(g:, 'terminal_shell', '') == ''
    if WINDOWS()
        let g:terminal_shell = 'cmd'
    else
        let g:terminal_shell = 'bash'
    endif
endif
let g:terminal_kill = 'term'
let g:terminal_auto_insert = 1
PackAdd 'vim-terminal-help'
nnoremap <silent> <M--> :call TerminalToggle()<cr>
if g:has_terminal == 2
    tnoremap <silent> <M--> <C-_>:call TerminalToggle()<cr>
else
    tnoremap <silent> <M--> <C-\><C-n>:call TerminalToggle()<cr>
endif
" --------------------------
" floaterm
" --------------------------
if get(g:, 'terminal_plus', '') == ''
    let g:terminal_plus = 'floaterm'
else
    let g:terminal_plus .= '-floaterm'
endif
let g:floaterm_open_command = 'drop'
if has("popupwin") && !MACOS() || exists('*nvim_open_win')
    let g:floaterm_wintype  = 'float'
    let g:floaterm_position = 'topright'
    let g:floaterm_width    = 0.45
    let g:floaterm_height   = 0.65
    nnoremap <silent><Tab>c :FloatermNew --height=0.80 --width=0.80 --position=center<Cr>
    nnoremap <silent><Tab>o :FloatermNew --height=0.65 --width=0.45 --position=topleft<Cr>
else
    let g:floaterm_wintype  = 'vsplit'
    let g:floaterm_position = 'right'
    let g:floaterm_width    = 0.4
endif
" key map
nnoremap <Tab>f :Floaterm
nnoremap <Tab>F :FloatermKill<Space>
nnoremap <Tab>+ :FloatermNew<Space>
let g:floaterm_keymap_new  = '<Nop>'
let g:floaterm_keymap_prev = '<M-{>'
let g:floaterm_keymap_next = '<M-}>'
tnoremap <C-u> <C-\><C-n>:FloatermUpdate
tnoremap <C-y> <C-\><C-n>:FloatermUpdate --position=
tnoremap <silent><M-}> <C-\><C-n>:FloatermNext<Cr>
tnoremap <silent><M-{> <C-\><C-n>:FloatermPrev<Cr>
tnoremap <silent><M-=> <C-\><C-n>:FloatermToggle<Cr>
nnoremap <silent><M-=>  :FloatermToggle<Cr>
nnoremap <silent><Tab>1 :FloatermFirst<Cr>
nnoremap <silent><Tab>0 :FloatermLast<Cr>
PackAdd 'vim-floaterm'
