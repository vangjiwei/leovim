let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#force_manual           = 0
let g:mucomplete#completion_delay       = 0
imap <expr> <down> mucomplete#extend_fwd("\<down>")
if g:python_version == 0
    let g:jedi#popup_on_dot = 0
    autocmd WinEnter *.py :MUcompleteAutoOff
    autocmd WinLeave *.py :MUcompleteAutoOn
else
    let g:jedi#popup_on_dot = 1
endif
if Installed('ultisnips')
    let g:mucomplete#ultisnips#match_at_start = 0
    let g:mucomplete#chains = {
                \ 'default' : ['path', 'omni', 'keyn', 'dict', 'ulti', 'uspl'],
                \ 'vim'     : ['path', 'cmd', 'keyn']
                \ }
else
    let g:mucomplete#chains = {
                \ 'default' : ['path', 'omni', 'keyn', 'dict', 'ulti', 'uspl'],
                \ 'vim'     : ['path', 'cmd', 'keyn']
                \ }
endif
