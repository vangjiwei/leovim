" goto last visited line
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" optional reset cursor on start:
aug resetCursor
    autocmd!
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
aug END
augroup CompleteModeChange
    " 离开InsertMode时，关闭补全，非paste模式
    autocmd InsertLeave * set nopaste
    " 补全完成后关闭预览窗口
    autocmd InsertLeave  * if pumvisible() == 0 | pclose | endif
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
" from https://github.com/antoinemadec/FixCursorHold.nvim
if has('nvim')
    let g:cursorhold_updatetime = get(g:, 'cursorhold_updatetime', 100)
    let g:fix_cursorhold_nvim_timer = -1
    set eventignore+=CursorHold,CursorHoldI
    augroup fix_cursorhold_nvim
        autocmd!
        autocmd CursorMoved  * call CursorHoldTimer()
        autocmd CursorMovedI * call CursorHoldITimer()
    augroup end
    function! CursorHold_Cb(timer_id) abort
        set eventignore-=CursorHold
        doautocmd <nomodeline> CursorHold
        set eventignore+=CursorHold
    endfunction
    function! CursorHoldI_Cb(timer_id) abort
        set eventignore-=CursorHoldI
        doautocmd <nomodeline> CursorHoldI
        set eventignore+=CursorHoldI
    endfunction
    function! CursorHoldTimer() abort
        call timer_stop(g:fix_cursorhold_nvim_timer)
        let g:fix_cursorhold_nvim_timer = timer_start(g:cursorhold_updatetime, 'CursorHold_Cb')
    endfunction
    function! CursorHoldITimer() abort
        call timer_stop(g:fix_cursorhold_nvim_timer)
        let g:fix_cursorhold_nvim_timer = timer_start(g:cursorhold_updatetime, 'CursorHoldI_Cb')
    endfunction
endif
" Comment highlighting
augroup SPECIALSTINGS
    autocmd!
    autocmd Syntax * call matchadd('Todo', '\v\W\zs' . g:todo_patterns . '(\(.{-}\))?:?', -1)
    autocmd Syntax * call matchadd('Todo', '\v\W\zs' . g:note_patterns . '(\(.{-}\))?:?', -2)
augroup END
" FOLDS
augroup FOLDS
    autocmd!
    autocmd FileType tex setl foldlevel=0 foldnestmax=1
    autocmd BufRead,BufNewFile *.c,*.cpp,*.cc setl foldlevel=0 foldnestmax=1
augroup END
" auto lcd current dir
augroup AUTOLCD
    " cd file dir
    autocmd WinEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://"   " terminal
                \ && bufname("") !~ "Rg"                   " rg
                \ && bufname("") !~ "outline"              " outline
                \ && bufname("")[0] != "!"                 " some special buf
                \ && getbufvar(winbufnr(winnr()), "&buftype") != "popup"
                \ | lcd %:p:h | endif
augroup END
nnoremap cd :lcd %:p:h<Cr>
" --------------------------
" file templates
" --------------------------
autocmd BufNewFile .gitignore          0r $LEOVIM_PATH/templates/gitignore.spec
autocmd BufNewFile .lintr              0r $LEOVIM_PATH/templates/lintr.spec
autocmd BufNewFile .radian_profile     0r $LEOVIM_PATH/templates/radian_profile.spec
autocmd BufNewFile projectionlist.json 0r $LEOVIM_PATH/templates/projectionlist.json.spec
" --------------------------
" swap exists ignore
" --------------------------
autocmd SwapExists * let v:swapchoice = 'o'
" --------------------------
" autoclose
" --------------------------
let s:autoclose_ft_buf = ['netrw', 'qf', 'preview', 'vista', 'aerial', 'tagbar', 'coc-explorer', 'neo-tree', 'fern', 'nvim-tree', 'nofile']
function! s:autoclose()
    if winnr('$') == 1
        return index(s:autoclose_ft_buf, getbufvar(winbufnr(winnr()), "&filetype")) >= 0 || index(s:autoclose_ft_buf, getbufvar(winbufnr(winnr()), "&buftype")) >= 0
    else
        return 0
    endif
endfunction
autocmd WinEnter * if s:autoclose() | q | endif
" --------------------------
" numbertoggle
" --------------------------
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
" -----------------------------------
" reset tab for vim python after source main.vim
" -----------------------------------
if exists("##SourcePost")
    augroup startvim
        autocmd!
        autocmd FileType vim,python autocmd SourcePost init.vim set shiftwidth=4 softtabstop=4 tabstop=4
    augroup END
endif
" ----------------------
" lspsaga
" ----------------------
augroup lspsaga_filetypes
    autocmd!
    autocmd FileType LspsagaHover nnoremap <buffer><nowait><silent> <Esc> <cmd>close!<cr>
augroup END
autocmd BufRead acwrite set ma
