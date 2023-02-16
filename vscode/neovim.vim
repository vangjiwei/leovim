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
nnoremap \| <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
nnoremap <C-o> <Cmd>call VSCodeNotify("workbench.action.navigateBack")<CR>
nnoremap <C-i> <Cmd>call VSCodeNotify("workbench.action.navigateForward")<CR>
" ------------------------
" movement
" ------------------------
function! s:toFirstCharOfScreenLine()
    call VSCodeNotify('cursorMove', { 'to': 'wrappedLineFirstNonWhitespaceCharacter' })
endfunction
function! s:toLastCharOfScreenLine()
    call VSCodeNotify('cursorMove', { 'to': 'wrappedLineLastNonWhitespaceCharacter' })
    " Offfset cursor moving to the right caused by calling VSCode command in Vim mode
    call VSCodeNotify('cursorLeft')
endfunction
nnoremap g0 <Cmd>call <SID>toFirstCharOfScreenLine()<CR>
nnoremap g$ <Cmd>call <SID>toLastCharOfScreenLine()<CR>
" Note: Using these in macro will break it
nnoremap gk <Cmd>call VSCodeNotify('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count1 })<CR>
nnoremap gj <Cmd>call VSCodeNotify('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count1 })<CR>
" ------------------------
" Find in files for word under cursor in vscode
" ------------------------
nnoremap s<Cr> <Cmd>call VSCodeNotify("workbench.action.findInFiles", {'query': expand('<cword>')})<CR>
nnoremap s;    <Cmd>call VSCodeNotify("editor.action.startFindReplaceAction")<Cr>
nnoremap s/    <Cmd>call VSCodeNotify("actions.find")<Cr>
" quickfix
nnoremap <C-.> <Cmd>call VSCodeNotify("keyboard-quickfix.openQuickFix")<CR>
nnoremap <C-a> <Cmd>call VSCodeNotify("editor.action.selectAll")<Cr>
xnoremap <C-x> <Cmd>call VSCodeNotifyVisual("editor.action.clipboardCutAction", 1)<Cr>
" enhanced
nnoremap <leader>w <Cmd>call VSCodeNotify("workbench.action.openView")<Cr>
nnoremap <leader>m <Cmd>call VSCodeNotify("workbench.action.openRecent")<Cr>
" debug
nnoremap <leader>d <Cmd>call VSCodeNotify("workbench.view.debug")<Cr>
nnoremap <leader>t <Cmd>call VSCodeNotify("workbench.action.debug.start")<Cr>
nnoremap <leader>R <Cmd>call VSCodeNotify("workbench.action.debug.restart")<Cr>
nnoremap <leader>n <Cmd>call VSCodeNotify("workbench.action.debug.continue")<Cr>
nnoremap <leader>i <Cmd>call VSCodeNotify("workbench.action.debug.stepIntoTarget")<Cr>
nnoremap <leader>s <Cmd>call VSCodeNotify("workbench.action.debug.stepInto")<Cr>
nnoremap <leader>o <Cmd>call VSCodeNotify("workbench.action.debug.stepOver")<Cr>
nnoremap <leader>u <Cmd>call VSCodeNotify("workbench.action.debug.stepOut")<Cr>
nnoremap <leader>q <Cmd>call VSCodeNotify("workbench.action.debug.stop")<Cr>
nnoremap <leader>p <Cmd>call VSCodeNotify("workbench.action.debug.pause")<Cr>
nnoremap <leader>C <Cmd>call VSCodeNotify("workbench.action.debug.configure")<Cr>
" breakpoint
nnoremap <leader>; <Cmd>call VSCodeNotify("workbench.action.debug.gotoNextBreakpoint")<Cr>
nnoremap <leader>, <Cmd>call VSCodeNotify("workbench.action.debug.gotoPreviousBreakpoint")<Cr>
nnoremap <leader>b <Cmd>call VSCodeNotify("editor.debug.action.toggleBreakpoint")<Cr>
nnoremap <leader>c <Cmd>call VSCodeNotify("editor.debug.action.conditionalBreakpoint")<Cr>
nnoremap <leader>f <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.addFunctionBreakpointAction")<Cr>
nnoremap <leader>E <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.enableAllBreakpoints")<Cr>
nnoremap <leader>D <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.disableAllBreakpoints")<Cr>
nnoremap <leader>B <Cmd>call VSCodeNotify("workbench.debug.viewlet.action.removeAllBreakpoints")<Cr>
" ------------------------
" autocmd
" ------------------------
source $CONFIG_PATH/autocmd.vim
au FileType r inoremap >> <space>%>%<space>
au FileType r inoremap << <space><-<space>
au FileType r inoremap ?? <space>\|><space>
