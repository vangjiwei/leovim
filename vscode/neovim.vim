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
xnoremap <C-S-P> <Cmd>call VSCodeNotifyVisual("workbench.action.showCommands", 1)<CR>
" ------------------------
" Find in files for word under cursor in vscode
" ------------------------
nnoremap s/    <Cmd>call VSCodeNotify("workbench.action.findInFiles", {'query': expand('<cword>')})<CR>
nnoremap s?    <Cmd>call VSCodeNotify("editor.action.startFindReplaceAction")<Cr>
nnoremap s<Cr> <Cmd>call VSCodeNotify("actions.find")<Cr>
nnoremap f<Cr> <Cmd>call VSCodeNotify("workbench.action.gotoSymbol")<Cr>
nnoremap <C-.> <Cmd>call VSCodeNotify("keyboard-quickfix.openQuickFix")<CR>
nnoremap <C-a> <Cmd>call VSCodeNotify("editor.action.selectAll")<Cr>
xnoremap <C-x> <Cmd>call VSCodeNotifyVisual("editor.action.clipboardCutAction", 1)<Cr>
" enhanced
nnoremap <leader>w <Cmd>call VSCodeNotify("workbench.action.openView")<Cr>
nnoremap <leader>m <Cmd>call VSCodeNotify("workbench.action.openRecent")<Cr>
nnoremap <leader>q <Cmd>q!<Cr>
" debug
nnoremap <leader>r <Cmd>call VSCodeNotify("workbench.action.debug.start")<Cr>
nnoremap <leader>R <Cmd>call VSCodeNotify("workbench.action.debug.restart")<Cr>
nnoremap <leader>n <Cmd>call VSCodeNotify("workbench.action.debug.continue")<Cr>
nnoremap <leader>t <Cmd>call VSCodeNotify("workbench.action.debug.stepIntoTarget")<Cr>
nnoremap <leader>s <Cmd>call VSCodeNotify("workbench.action.debug.stepInto")<Cr>
nnoremap <leader>o <Cmd>call VSCodeNotify("workbench.action.debug.stepOver")<Cr>
nnoremap <leader>u <Cmd>call VSCodeNotify("workbench.action.debug.stepOut")<Cr>
nnoremap <leader>Q <Cmd>call VSCodeNotify("workbench.action.debug.stop")<Cr>
nnoremap <leader>p <Cmd>call VSCodeNotify("workbench.action.debug.pause")<Cr>
nnoremap <leader>d <Cmd>call VSCodeNotify("workbench.view.debug")<Cr>
nnoremap <leader>c <Cmd>call VSCodeNotify("workbench.action.debug.configure")<Cr>
" breakpoint
nnoremap <leader>, <Cmd>call VSCodeNotify("workbench.action.debug.gotoPreviousBreakpoint")<Cr>
nnoremap <leader>; <Cmd>call VSCodeNotify("workbench.action.debug.gotoNextBreakpoint")<Cr>
nnoremap <leader>b <Cmd>call VSCodeNotify("editor.debug.action.toggleBreakpoint")<Cr>
nnoremap <leader>B <Cmd>call VSCodeNotify("editor.debug.action.conditionalBreakpoint")<Cr>
nnoremap <leader>f <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.addFunctionBreakpointAction")<Cr>
nnoremap <leader>a <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.enableAllBreakpoints")<Cr>
nnoremap <leader>D <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.disableAllBreakpoints")<Cr>
nnoremap <leader>C <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.removeAllBreakpoints")<Cr>
" ------------------------
" autocmd
" ------------------------
source $SETTINGS_PATH/autocmd.vim
au FileType r inoremap >> <space>%>%<space>
au FileType r inoremap << <space><-<space>
au FileType r inoremap ?? <space>\|><space>
