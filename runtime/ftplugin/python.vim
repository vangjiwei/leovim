set shiftwidth=4 softtabstop=4 tabstop=4
au BufWritePre <buffer> :%retab
" ---------------------------------------
" nvim-dap-python
" ---------------------------------------
if Installed('nvim-dap-python')
    nnoremap <silent> <leader>wm <cmd>lua require('dap-python').test_method()<CR>
    nnoremap <silent> <leader>wc <cmd>lua require('dap-python').test_class()<CR>
    xnoremap <silent> <leader>wv <ESC><cmd>lua require('dap-python').debug_selection()<CR>
endif
