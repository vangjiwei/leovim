setlocal wrap foldcolumn=0 colorcolumn=  cursorline
try
    setlocal signcolumn=no
catch
endtry
set norelativenumber
nnoremap <silent><buffer>qq <C-w>z
nnoremap <silent><buffer>p  :PreviewQuickfix<cr>
nnoremap <silent><buffer>Q  :cclose<Cr><C-o>
