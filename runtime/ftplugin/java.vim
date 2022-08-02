set commentstring=//\ %s
" cd module root
command! CDM cd %:h | exec 'cd' fnameescape(fnamemodify(findfile("pom.xml", escape(expand('%:p:h'), ' ') . ";"), ':h'))
nnoremap <leader>cm :CDM<CR>
