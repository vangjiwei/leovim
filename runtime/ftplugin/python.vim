au BufWritePre <buffer> :%retab
set shiftwidth=4 softtabstop=4 tabstop=4
" ---------------------------------------
" nvim-dap-python
" ---------------------------------------
if Installed('nvim-dap-python')
    nnoremap <silent> <M-h>m <cmd>lua require('dap-python').test_method()<CR>
    nnoremap <silent> <M-h>c <cmd>lua require('dap-python').test_class()<CR>
    xnoremap <silent> <M-h>v <ESC><cmd>lua require('dap-python').debug_selection()<CR>
endif
