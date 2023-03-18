" ------------------------
" yank && paste
" ------------------------
function! YankFromBeginning() abort
    let original_cursor_position = getpos('.')
    if has('clipboard')
        exec('normal! v^"*y')
        echo "Yank from line beginning to clipboard"
    else
        exec('normal! v^y')
    endif
    call setpos('.', original_cursor_position)
endfunction
nnoremap <Leader>Y :call YankFromBeginning()<Cr>
cnoremap <M-'> <C-r>"
inoremap <M-'> <C-r>"
cnoremap <C-y> <C-r>"
" for complete engine
if index(['', 'apc'], g:complete_engine) >= 0
    imap <expr><C-y> pumvisible()? "\<C-y>":"\<C-r>\""
    imap <expr><C-e> pumvisible()? "\<C-e>":"\<C-o>A"
endif
if has('clipboard')
    nnoremap <M-a> :%y*<Cr>
    " autocmd
    if exists("##ModeChanged")
        au ModeChanged *:s set clipboard=
        au ModeChanged s:* set clipboard=unnamedplus
    endif
    if UNIX()
        nnoremap <M-c>+ viw"+y
        xnoremap <M-c>+ "+y
    else
        nnoremap <M-c>+ viw"*y
        xnoremap <M-c>+ "*y"
    endif
    " yank
    nnoremap Y "*y$:echo "Yank to the line ending to clipboard"<Cr>
    " ctrl c
    if has('nvim')
        xnoremap <C-c> "*y:echo "Yank selected to clipboard" \| let @*=trim(@*)<Cr>
    else
        xnoremap <C-c> "*y:echo "Yank selected to clipboard"<Cr>
    endif
    " paste
    cnoremap <M-v> <C-r>*
    cnoremap <S-Insert> <C-r>*
    inoremap <M-v> <C-r>*
    inoremap <S-Insert> <C-r>*
    nnoremap <M-v> "*P
    nnoremap <S-Insert> "*P
    xnoremap <M-v> "*P
    xnoremap <S-Insert> "*P
    " M-x/y
    nnoremap <silent><M-x> "*x:let  @*=trim(@*)<Cr>
    xnoremap <silent><M-x> "*x:let  @*=trim(@*)<Cr>
    nnoremap <silent><M-y> "*X:let  @*=trim(@*)<Cr>
    xnoremap <silent><M-y> "*X:let  @*=trim(@*)<Cr>
    nnoremap <M-X> "*dd
    xnoremap <M-X> "*dd
else
    nnoremap Y y$
    xnoremap <C-c> y
    nnoremap <M-a> :%y"<Cr>
    cnoremap <M-v> <C-r>"
    inoremap <M-v> <C-r>"
    nnoremap <M-v> P
    xnoremap <M-v> P
    " M-x/y
    nnoremap <M-x> x
    xnoremap <M-x> x
    nnoremap <M-y> X
    xnoremap <M-y> X
    nnoremap <M-X> S
    xnoremap <M-X> S
endif
nnoremap <leader>vp viwp
" yank from beginning / to ending
nnoremap <Tab>y :0,-y<Cr>
nnoremap <Tab>Y vGy
" del/bs
inoremap <M-x> <Del>
inoremap <M-y> <BS>
" switch 2 words
xnoremap <M-V> <Esc>`.``gvp``P
" ------------------------
" pastemode toggle
" ------------------------
inoremap <M-i> <C-\><C-o>:set paste<Cr>
nnoremap <M-i> :set nopaste! nopaste?<CR>
" --------------------
" registers
" --------------------
if Installed('leaderf-registers')
    nnoremap <silent> <M-'> :LeaderfPaste<Cr>
    inoremap <silent> <M-'> <ESC>:LeaderfPasteI<Cr>
    xnoremap <silent> <M-'> :<C-u>LeaderfPasteV<Cr>
elseif Installed('fzf-registers')
    nnoremap <silent> <M-'> :FZFRegisterPaste<Cr>
    inoremap <silent> <M-'> <C-o>:FZFRegisterPaste<Cr>
    xnoremap <silent> <M-'> :<C-u>FZFRegisterPasteV<Cr>
elseif InstalledTelescope()
    nnoremap <silent> <M-'> :Telescope registers<Cr>
    inoremap <silent> <M-'> <C-o>:Telescope registers<Cr>
    xnoremap <silent> <M-'> :<C-u>Telescope registers<Cr>
endif
" ------------------------
" copy to register
" ------------------------
for i in range(26)
    let l_char = nr2char(char2nr('a') + i)
    let u_char = nr2char(char2nr('A') + i)
    exec 'nnoremap <M-c>' . l_char . ' viw"'. l_char . 'y'
    exec 'nnoremap <M-c>' . u_char . ' viw"'. u_char . 'y'
    exec 'xnoremap <M-c>' . l_char . ' "'. l_char . 'y'
    exec 'xnoremap <M-c>' . u_char . ' "'. u_char . 'y'
endfor
