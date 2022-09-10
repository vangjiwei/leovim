" ------------------------
" pastemode toggle
" ------------------------
imap <M-o> <C-\><C-o>:set paste<Cr>
nmap <M-o> :set nopaste! nopaste?<CR>
" --------------------
" registers
" --------------------
if Installed('leaderf-registers')
    nnoremap <silent> <M-v> :LeaderfPaste<Cr>
    inoremap <silent> <M-v> <C-o>:LeaderfPasteI<Cr>
    xnoremap <silent> <M-v> :<C-u>LeaderfPasteV<Cr>
    nnoremap <silent> <M-a> :LeaderfAppend<Cr>
    inoremap <silent> <M-a> <C-o>:LeaderfAppendI<Cr>
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
" ------------------------
" yank && paste using M-
" ------------------------
if has('clipboard')
    nnoremap <M-c>+ viw"+y
    nnoremap <M-c>* viw'*y
    xnoremap <M-c>+ "+y
    xnoremap <M-c>* "*y"
    if exists("##ModeChanged")
        au ModeChanged *:s set clipboard=
        au ModeChanged s:* set clipboard=unnamedplus
    endif
    if has('nvim') && !InstalledTelescope()
        if WINDOWS()
            nnoremap <silent><M-x> "+x:let  @+=trim(@+)<Cr>
            xnoremap <silent><M-x> "+x:let  @+=trim(@+)<Cr>
            nnoremap <silent><M-y> "+X:let  @+=trim(@+)<Cr>
            nnoremap <silent><M-y> "+X:let  @+=trim(@+)<Cr>
            nnoremap <silent><M-C> "+yy:let @+=trim(@+)<Cr>:echo "Yank the line"<Cr>
            nnoremap <silent>Y     "+y$:let @+=trim(@+)<Cr>:echo "Yank to line ending"<Cr>
            nnoremap <M-X> "+dd
            xnoremap <M-X> "+dd
        else
            nnoremap <silent><M-x> "*x:let  @*=trim(@*)<Cr>
            xnoremap <silent><M-x> "*x:let  @*=trim(@*)<Cr>
            nnoremap <silent><M-y> "*X:let  @*=trim(@*)<Cr>
            nnoremap <silent><M-y> "*X:let  @*=trim(@*)<Cr>
            nnoremap <silent><M-C> "*yy:let @*=trim(@*)<Cr>:echo "Yank the line"<Cr>
            nnoremap <silent>Y     "*y$:let @*=trim(@*)<Cr>:echo "Yank to line ending"<Cr>
            nnoremap <M-X> "*dd
            xnoremap <M-X> "*dd
        endif
    else
        nnoremap <silent><M-x> "*x
        xnoremap <silent><M-x> "*x
        nnoremap <silent><M-y> "*X
        xnoremap <silent><M-y> "*X
        nnoremap <silent><M-C> "*yy:echo "Yank the line"<Cr>
        nnoremap <silent>Y     "*y$:echo "Yank to line ending"<Cr>
        nnoremap <M-X> "*dd
        xnoremap <M-X> "*dd
    endif
else
    nnoremap <silent><M-x> x
    xnoremap <silent><M-x> x
    nnoremap <silent><M-y> X
    xnoremap <silent><M-y> X
    nnoremap <silent><M-C> yy:echo "Yank the line"<Cr>
    nnoremap <silent>Y     y$:echo "Yank to line ending"<Cr>
    nnoremap <M-X> S
    xnoremap <M-X> S
endif
inoremap <M-x> <Del>
inoremap <M-y> <BS>
" ----------------------
" switch 2 words
" ----------------------
xnoremap <M-V> <Esc>`.``gvp``P
" ----------------------
" coc yank
" ----------------------
if Installed('coc.nvim')
    nnoremap <silent> <M-V> :CocFzfList yank<Cr>
endif
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
