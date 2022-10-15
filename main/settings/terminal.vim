" --------------------------
" set termwinkey
" --------------------------
if has('patch-8.1.1')
    set termwinkey=<C-_>
    let g:has_terminal=2
endif
tmap <expr> <C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
tmap <M-q> <C-\><C-n>:q!<CR>
tmap <C-v> <C-\><C-n>
tmap <C-g> <C-\><C-n>
" --------------------------
" open terminal
" --------------------------
if has('nvim')
    if WINDOWS()
        nnoremap <Tab>m :tabe term://cmd<cr>i
    else
        nnoremap <Tab>m :tabe term://bash<cr>i
    endif
else
    if WINDOWS()
        nnoremap <Tab>m :tab terminal<Cr>cmd<Cr>
    else
        nnoremap <Tab>m :tab terminal<Cr>bash<Cr>
    endif
endif
" --------------------------
" paste
" --------------------------
if g:has_terminal == 1
    tmap <M-'> <C-\><C-n>""pa
else
    tmap <M-'> <C-_>""
endif
if has('clipboard')
    if g:has_terminal == 1
        tmap <M-v> <C-\><C-n>"*pa
    else
        tmap <M-v> <C-_>"*
    endif
else
    if has('nvim')
        tmap <M-v> <C-\><C-n>""pa
    else
        tmap <M-v> <C-_>""
    endif
endif
" --------------------------
" terminal-help
" --------------------------
PackAdd 'vim-terminal-help'
let g:terminal_plus = 'help'
if get(g:, 'terminal_shell', '') == ''
    if WINDOWS()
        let g:terminal_shell = 'cmd'
    else
        let g:terminal_shell = 'bash'
    endif
endif
let g:terminal_key             = '<M-->'
let g:terminal_kill            = 'term'
let g:terminal_auto_insert     = 1
let g:terminal_skip_key_init   = 1
let g:terminal_default_mapping = 0
" --------------------------
" floaterm
" --------------------------
PackAdd 'vim-floaterm'
if get(g:, 'terminal_plus', '') == ''
    let g:terminal_plus = 'floaterm'
else
    let g:terminal_plus .= '-floaterm'
endif
let g:floaterm_open_command = 'drop'
if g:has_popup_float && get(g:, 'floaterm_floating', 1)
    let g:floaterm_floating = 1
    let g:floaterm_wintype  = 'float'
    let g:floaterm_position = 'topright'
    let g:floaterm_width    = 0.45
    let g:floaterm_height   = 0.65
    nnoremap <silent><Tab>f :FloatermNew --height=0.8 --width=0.8 --position=center<Cr>
else
    let g:floaterm_floating = 0
    let g:floaterm_wintype  = 'vsplit'
    let g:floaterm_position = 'right'
    let g:floaterm_width    = 0.4
endif
" key map
let g:floaterm_keymap_new  = '<Nop>'
let g:floaterm_keymap_prev = '<M-{>'
let g:floaterm_keymap_next = '<M-}>'
nnoremap <M-j>k :FloatermKill<Cr>
nnoremap <M-j>n :FloatermNew<Space>
nnoremap <M-j>F :Floaterm<Tab>
nnoremap <M-j>u :FloatermUpdate<Tab>
nnoremap <M-j>1 :FloatermFirst<Cr>
nnoremap <M-j>l :FloatermLast<Cr>
nnoremap <M-j>n :FloatermNext<Cr>
nnoremap <M-j>p :FloatermPrev<Cr>
nnoremap <silent> <M-=> :FloatermToggle<CR>
tnoremap <silent> <M-=> <C-\><C-n>:FloatermToggle<CR>
