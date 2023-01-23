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
nnoremap gy :call YankFromBeginning()<Cr>
cnoremap <M-'> <C-r>"
inoremap <M-'> <C-r>"
cnoremap <C-y> <C-r>"
" for complete engine
if g:advanced_complete_engine == 0 && g:complete_engine != 'mcm'
    imap <expr><C-y> pumvisible()? "\<C-y>":"\<C-r>\""
endif
if has('clipboard')
    if UNIX()
        nnoremap <M-c>+ viw"+y
        xnoremap <M-c>+ "+y
    else
        nnoremap <M-c>+ viw"*y
        xnoremap <M-c>+ "*y"
    endif
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
" yank from beginning / to ending
nnoremap ,y :0,-y<Cr>
nnoremap ,Y vGy
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
    exec 'nnoremap <leader>Y' . l_char . ' "'. l_char . 'yy'
    exec 'nnoremap <leader>Y' . u_char . ' "'. u_char . 'yy'
endfor