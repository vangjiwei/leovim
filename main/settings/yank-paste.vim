" ------------------------
" pastemode toggle
" ------------------------
imap <M-i> <C-\><C-o>:set paste<Cr>
nmap <M-i> :set nopaste! nopaste?<CR>
" --------------------
" registers
" --------------------
if Installed('leaderf-registers')
    nnoremap <silent> <M-v> :LeaderfPaste<Cr>
    inoremap <silent> <M-v> <ESC>:LeaderfPasteI<Cr>
    xnoremap <silent> <M-v> :<C-u>LeaderfPasteV<Cr>
    nnoremap <silent> <M-a> :LeaderfAppend<Cr>
    inoremap <silent> <M-a> <ESC>:LeaderfAppendI<Cr>
    xnoremap <silent> <M-a> :<C-u>LeaderfAppendV<Cr>
elseif Installed('fzf-registers')
    nnoremap <silent> <M-v> :FZFRegisterPaste<Cr>
    inoremap <silent> <M-v> <C-o>:FZFRegisterPaste<Cr>
    xnoremap <silent> <M-v> :<C-u>FZFRegisterPasteV<Cr>
    nnoremap <silent> <M-a> :FZFRegisterAppend<Cr>
    inoremap <silent> <M-a> <C-o>:FZFRegisterAppend<Cr>
    xnoremap <silent> <M-a> :<C-u>FZFRegisterAppendV<Cr>
elseif InstalledTelescope()
    nnoremap <silent> <M-v> :Telescope registers<Cr>
    inoremap <silent> <M-v> <C-o>:Telescope registers<Cr>
    xnoremap <silent> <M-v> :<C-u>Telescope registers<Cr>
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
