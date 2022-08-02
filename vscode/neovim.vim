" ------------------------
" hl * # S
" ------------------------
nmap *  *``
nmap #  #``
nmap g* g*``
nmap g# g#``
" ------------------------
" vscode speicially mapping
" ------------------------
function! VSCodeNotifyVisual(cmd, leaveSelection, ...)
    let mode = mode()
    if mode ==# 'V'
        let startLine = line('v')
        let endLine = line('.')
        call VSCodeNotifyRange(a:cmd, startLine, endLine, a:leaveSelection, a:000)
    elseif mode ==# 'v' || mode ==# "\<C-v>"
        let startPos = getpos('v')
        let endPos = getpos('.')
        call VSCodeNotifyRangePos(a:cmd, startPos[1], endPos[1], startPos[2], endPos[2] + 1, a:leaveSelection, a:000)
    else
        call VSCodeNotify(a:cmd, a:000)
    endif
endfunction
xnoremap <C-S-P> <Cmd>call VSCodeNotifyVisual('workbench.action.showCommands', 1)<CR>
" ------------------------
" Find in files for word under cursor in vscode
" ------------------------
nnoremap s<Tab> <Cmd>call VSCodeNotify('workbench.action.findInFiles', {'query': expand('<cword>')})<CR>
nnoremap s<Cr>  <Cmd>call VSCodeNotify('actions.find')<Cr>
nnoremap f<Tab> <Cmd>call VSCodeNotify('editor.action.startFindReplaceAction')<Cr>
nnoremap f<cr>  <Cmd>call VSCodeNotify('azALDevTools.SymbolsTreeProvider.focus')<Cr>
nnoremap <C-.>  <Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>
nnoremap <C-a>  <Cmd>call VSCodeNotify('editor.action.selectAll')<Cr>
xnoremap <C-x>  <Cmd>call VSCodeNotifyVisual('editor.action.clipboardCutAction', 1)<Cr>
" enhanced
nnoremap <leader>w <Cmd>call VSCodeNotify('workbench.action.openView')<Cr>
nnoremap <leader>m <Cmd>call VSCodeNotify('workbench.action.openRecent')<Cr>
" ------------------------
" comment
" ------------------------
xmap gc         <Plug>VSCodeCommentary
nmap gc         <Plug>VSCodeCommentary
omap gc         <Plug>VSCodeCommentary
xmap <leader>cc <Plug>VSCodeCommentaryLine
nmap <leader>cc <Plug>VSCodeCommentaryLine
omap <leader>cc <Plug>VSCodeCommentaryLine
" ------------------------
" autocmd
" ------------------------
source $SETTINGS_PATH/autocmd.vim
au FileType r inoremap >> <space>%>%<space>
au FileType r inoremap << <space><-<space>
au FileType r inoremap ?? <space>\|><space>
