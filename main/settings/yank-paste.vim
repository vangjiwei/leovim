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
cnoremap <C-y> <C-r>"
inoremap <M-'> <C-r>"
if has('clipboard')
    if UNIX()
        nnoremap <M-c>+ viw"+y
        xnoremap <M-c>+ "+y
    else
        nnoremap <M-c>+ viw"*y
        xnoremap <M-c>+ "*y"
    endif
    cnoremap <M-v> <C-r>*
    inoremap <M-v> <C-r>*
    nnoremap <M-v> "*P
    xnoremap <M-v> "*P
    " M-x/y
    nnoremap <silent><M-x> "*x:let  @*=trim(@*)<Cr>
    xnoremap <silent><M-x> "*x:let  @*=trim(@*)<Cr>
    nnoremap <silent><M-y> "*X:let  @*=trim(@*)<Cr>
    xnoremap <silent><M-y> "*X:let  @*=trim(@*)<Cr>
    nnoremap <M-X> "*dd
    xnoremap <M-X> "*dd
    " yank for beginning / to ending
    nnoremap ,y :0,-"*y<Cr>
    nnoremap ,Y vG"*y
else
    cnoremap <M-v> <C-r>"
    inoremap <M-v> <C-r>"
    nnoremap <M-v> P
    xnoremap <M-v> P
    " M-x/y
    nnoremap <M-X> S
    xnoremap <M-X> S
    nnoremap <M-x> x
    xnoremap <M-x> x
    nnoremap <M-y> X
    xnoremap <M-y> X
    " yank for beginning / to ending
    nnoremap ,y :0,-y<Cr>
    nnoremap ,Y vGy
endif
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
    xnoremap <silent> <M-'> :<C-u>LeaderfPasteV<Cr>
    inoremap <silent> <M-'> <ESC>:LeaderfPasteI<Cr>
    nnoremap <silent> <M-a> :LeaderfAppend<Cr>
    xnoremap <silent> <M-a> :<C-u>LeaderfAppendV<Cr>
    inoremap <silent> <M-a> <ESC>:LeaderfAppendI<Cr>
elseif Installed('fzf-registers')
    nnoremap <silent> <M-'> :FZFRegisterPaste<Cr>
    xnoremap <silent> <M-'> :<C-u>FZFRegisterPasteV<Cr>
    inoremap <silent> <M-'> <C-o>:FZFRegisterPaste<Cr>
    nnoremap <silent> <M-a> :FZFRegisterAppend<Cr>
    xnoremap <silent> <M-a> :<C-u>FZFRegisterAppendV<Cr>
    inoremap <silent> <M-a> <C-o>:FZFRegisterAppend<Cr>
elseif InstalledTelescope()
    nnoremap <silent> <M-'> :Telescope registers<Cr>
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
