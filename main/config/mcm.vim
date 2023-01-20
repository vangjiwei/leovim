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
let g:mucomplete#chains = {}
let g:mucomplete#chains.vim = ['path', 'cmd', 'keyn']
if Installed('ultisnips')
    let g:mucomplete#ultisnips#match_at_start = 0
    let g:mucomplete#chains.default = ['path', 'omni', 'keyn', 'ulti', 'dict']
else
    let g:mucomplete#chains.default = ['path', 'omni', 'keyn', 'dict']
endif
function! MapTabCr(istab) abort
	let istab = a:istab
	if pumvisible()
		if istab > 0
            if Installed('ultisnips') && (UltiSnips#CanExpandSnippet() || UltiSnips#CanJumpForwards())
                return UltiSnips#ExpandSnippetOrJump()
            elseif empty(get(v:, 'completed_item', {}))
                return "\<C-n>"
			else
			    return "\<C-y>"
			endif
		else
			return "\<C-y>"
		endif
	else
		if istab > 0
			return "\<Tab>"
		else
			return "\<Cr>"
		endif
	endif
endfunction
au BufEnter * exec "imap <silent> <Tab> <C-R>=MapTabCr(1)<cr>"
au BufEnter * exec "imap <silent> <Cr>  <C-R>=MapTabCr(0)<cr>"
au BufEnter * exec "imap <expr><C-y> pumvisible()? '\<C-y>' : '\<C-r>\"'"
