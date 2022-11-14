" toggle between GlobalEnv or Libraries
" NOTE:  found the functions in https://github.com/jalvesaq/Nvim-R/blob/master/ftplugin/rbrowser.vim
function! ToggleEnvLib()
    if string(g:SendCmdToR) == "function('SendCmdToR_fake')"
        call RWarningMsg("The Object Browser can be opened only if R is running.")
        return
    elseif string(g:SendCmdToR) == "function('SendCmdToR_NotYet')"
        call RWarningMsg("R is not ready yet")
        return
    endif
    " below is copied from rbrowser.vim
    if get(t:, 'robjrb_status', 0) > 0
        call UpdateOB('both')
        if g:rplugin.curview == "libraries"
            let g:rplugin.curview = "GlobalEnv"
            call JobStdin(g:rplugin.jobs["ClientServer"], "31\n")
        elseif g:rplugin.curview == "GlobalEnv"
            let g:rplugin.curview = "libraries"
            call JobStdin(g:rplugin.jobs["ClientServer"], "321\n")
        endif
    else
        let s:filetype = &filetype
        call RObjBrowser()
        call UpdateOB('both')
        let g:rplugin.curview = "GlobalEnv"
        call JobStdin(g:rplugin.jobs["ClientServer"], "31\n")
        let t:robjrb_status = 1
        if s:filetype != 'rbrowser'
            execute "wincmd h"
            if &buftype =~ 'term'
                execute "wincmd k"
            endif
        endif
        redraw
    endif
endfunction
command! ToggleEnvLib call ToggleEnvLib()
command! ToggleObjBrw call RObjBrowser()
nnoremap <silent> q<Cr>  :ToggleObjBrw<CR>
nnoremap <silent> q<Tab> :ToggleEnvLib<Cr>

nnoremap cf :call SendFunctionToR('echo', "down")<CR>
nnoremap c, :call SendLineToR("down")<CR>
xnoremap c, :call SendLineToR("down")<CR>
nnoremap ch :call SendLineToR("stay")<CR>
xnoremap ch :call SendLineToR("stay")<CR>
nnoremap c; viB:call SendLineToR("down")<CR>
nnoremap cL :call RClearConsole()<Cr>
nnoremap cK :call RClearAll()<Cr>

nnoremap <leader>C :call SendAboveLinesToR()<CR>
nnoremap <leader>E VG:call SendLineToR('down')<CR>
nnoremap <leader>I :call SendLineToRAndInsertOutput()<CR>0

nnoremap <leader>t :call RAction('viewobj')<CR>
" input
inoremap %% <space>%>%<space>
inoremap >> <space>\|><space>
inoremap << <space><-<space>
" run script
nnoremap <M-R> :call StartR('R')<Cr>
nnoremap <M-B> :RStop<Cr>
nnoremap <M-T> :AsyncRun! -cwd=$(VIM_FILEDIR) -mode=term -pos=tab -focus=1 Rscript "$(VIM_FILEPATH)"<Cr>
if get(g:, 'terminal_plus', '') =~ 'floaterm'
    nnoremap <M-F> :AsyncRun! -cwd=$(VIM_FILEDIR) -mode=term -pos=floaterm_reuse Rscript "$(VIM_FILEPATH)"<Cr>
endif
if get(g:, 'R_external_tmux', 1) == 1 && $TMUX != ''
    let R_external_term = 'tilix -a session-add-down -e'
    let R_source        = '~/.leovim.conf/scripts/tmux_split.vim'
endif
