" --------------------------
" dict
" --------------------------
PackAdd 'vim-dict'
" -----------------------
" ultisnips
" -----------------------
if Installed('ultisnips')
    let g:UltiSnipsNoPythonWarning     = 0
    let g:UltiSnipsExpandTrigger       = "<Nop>"
    let g:UltiSnipsListSnippets        = "<C-l>"
    let g:UltiSnipsJumpForwardTrigger  = "<C-f>"
    let g:UltiSnipsJumpBackwardTrigger = "<C-b>"
    let g:UltiSnipsSnippetDirectories  = ["UltiSnips"]
    let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = $LEOVIM_PATH . "/UltiSnips"
elseif Installed('luasnip')
    smap <silent><C-f> <cmd>lua require('luasnip').jump(1)<Cr>
    smap <silent><C-b> <cmd>lua require('luasnip').jump(-1)<Cr>
    imap <silent><expr><C-f> luasnip#jumpable(1)  ? '<Plug>luasnip-jump-next' : '<C-o>A'
    imap <silent><expr><C-b> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-o>I'
    imap <silent><expr><C-e> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    smap <silent><expr><C-e> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
endif
if Installed('leaderf-snippet')
    let g:Lf_PreviewResult = get(g:, 'Lf_PreviewResult', {})
    let g:Lf_PreviewResult.snippet = 1
    inoremap <silent><C-x><C-x> <C-\><C-o>:Leaderf snippet<Cr>
elseif Installed('coc.nvim')
    inoremap <silent><C-x><C-x> <C-\><C-o>:CocFzfList snippets<Cr>
endif
" -----------------------
" FZF
" -----------------------
if InstalledFZF()
    imap <c-x><c-l> <plug>(fzf-complete-line)
    imap <expr><c-x><c-f> fzf#vim#complete#path('rg --files')
endif
