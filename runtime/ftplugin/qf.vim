setlocal wrap foldcolumn=0 colorcolumn=  cursorline
try
    setlocal signcolumn=no
catch
endtry
set norelativenumber
nnoremap <silent><buffer> qq <C-w>z
nnoremap <silent><buffer> Q  <C-w>z
nnoremap <silent><buffer>p     :PreviewQuickfix<cr>
nnoremap <silent><buffer><C-p> :PreviewQuickfix<cr>
nnoremap <silent><buffer>c     :cclose<Cr><C-o>
nnoremap <silent><buffer><C-n> :cclose<Cr><C-o>
