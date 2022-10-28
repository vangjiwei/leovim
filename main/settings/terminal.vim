" --------------------------
" set termwinkey
" --------------------------
if has('patch-8.1.1')
    set termwinkey=<C-_>
    let g:has_terminal=2
else
    let g:has_terminal=1
endif
tnoremap <expr> <C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
tnoremap <M-q> <C-\><C-n>:q!<CR>
tnoremap <M-w> <C-\><C-n>:ChooseWin<CR>
tnoremap <C-g> <C-\><C-n>
tnoremap <silent><M-}> <C-\><C-n>:FloatermNext<Cr>
tnoremap <silent><M-{> <C-\><C-n>:FloatermPrev<Cr>
" --------------------------
" XXX: cannot paste in floaterm when using vim9.0
" --------------------------
if g:has_terminal == 1
    tnoremap <C-v> <C-\><C-n>""pa
    tnoremap <M-'> <C-\><C-n>""pa
else
    tnoremap <C-v> <C-_>""
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
if get(g:, 'floaterm_floating', 1) > 0
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
nnoremap <M-j>f :Floaterm<Tab>
nnoremap <M-j>u :FloatermUpdate<Tab>
nnoremap <M-j>h :FloatermFirst<Cr>
nnoremap <M-j>l :FloatermLast<Cr>
nnoremap <silent> <M-=> :FloatermToggle<CR>
tnoremap <silent> <M-=> <C-\><C-n>:FloatermToggle<CR>
