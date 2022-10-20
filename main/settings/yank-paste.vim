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
if has('clipboard')
    if UNIX()
        nnoremap <M-c>+ viw"+y
        xnoremap <M-c>+ "+y
    else
        nnoremap <M-c>+ viw"*y
        xnoremap <M-c>+ "*y"
    endif
    cnoremap <C-y> <C-r>*
    inoremap <C-v> <C-r>*
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
    cnoremap <C-y> <C-r>"
    inoremap <C-v> <C-r>"
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
" yank from "
cnoremap <M-v> <C-r>"
cnoremap <M-'> <C-r>"
inoremap <M-'> <C-r>"
" ------------------------
" pastemode toggle
" ------------------------
inoremap <M-i> <C-\><C-o>:set paste<Cr>
nnoremap <M-i> :set nopaste! nopaste?<CR>
" --------------------
" registers
" --------------------
if Installed('leaderf-registers')
    nnoremap <silent> <M-v> :LeaderfPaste<Cr>
    xnoremap <silent> <M-v> :<C-u>LeaderfPasteV<Cr>
    inoremap <silent> <M-v> <ESC>:LeaderfPasteI<Cr>
    nnoremap <silent> <M-a> :LeaderfAppend<Cr>
    xnoremap <silent> <M-a> :<C-u>LeaderfAppendV<Cr>
    inoremap <silent> <M-a> <ESC>:LeaderfAppendI<Cr>
elseif Installed('fzf-registers')
    nnoremap <silent> <M-v> :FZFRegisterPaste<Cr>
    xnoremap <silent> <M-v> :<C-u>FZFRegisterPasteV<Cr>
    inoremap <silent> <M-v> <C-o>:FZFRegisterPaste<Cr>
    nnoremap <silent> <M-a> :FZFRegisterAppend<Cr>
    xnoremap <silent> <M-a> :<C-u>FZFRegisterAppendV<Cr>
    inoremap <silent> <M-a> <C-o>:FZFRegisterAppend<Cr>
elseif InstalledTelescope()
    nnoremap <silent> <M-v> :Telescope registers<Cr>
    xnoremap <silent> <M-v> :<C-u>Telescope registers<Cr>
    inoremap <silent> <M-'> <C-o>:Telescope registers<Cr>
    nnoremap <M-a> ggVG
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
