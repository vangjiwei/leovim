" ------------------------
" pastemode toggle
" ------------------------
imap <M-I> <C-\><C-o>:set paste<Cr>
nmap <M-I> :set nopaste! nopaste?<CR>
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
" ----------------------
" osc52 yankpost
" ----------------------
if exists("##TextYankPost") && UNIX() && exists('*trim')
    function! s:raw_echo(str)
        if filewritable('/dev/fd/2')
            call writefile([a:str], '/dev/fd/2', 'b')
        else
            exec("silent! !echo " . shellescape(a:str))
            redraw!
        endif
    endfunction
    function! s:copy() abort
        let c = join(v:event.regcontents,"\n")
        if len(trim(c)) == 0
            return
        endif
        let c64 = system("base64", c)
        if $TMUX == ''
            let s = "\e]52;c;" . trim(c64) . "\x07"
        else
            let s = "\ePtmux;\e\e]52;c;" . trim(c64) . "\x07\e\\"
        endif
        call s:raw_echo(s)
    endfunction
    autocmd TextYankPost * call s:copy()
endif
