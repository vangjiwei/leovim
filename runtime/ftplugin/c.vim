set commentstring=//\ %s
" cpp-mode
if Installed('cpp-mode')
    nnoremap <leader>wy :CopyCode<cr>
    nnoremap <leader>wp :PasteCode<cr>
    nnoremap <leader>wg :GoToFunImpl<cr>
    nnoremap <leader>ws :Switch<cr>
    nnoremap <leader>wf :FormatFunParam<cr>
    nnoremap <leader>wF :FormatIf<cr>
    nnoremap <leader>wt :GenTryCatch<cr>
    xnoremap <leader>wt :GenTryCatch<cr>
endif
" ccls
if Installed('vim-ccls')
    nnoremap <leader>wl :Ccls<Tab>
    nnoremap <leader>wb :CclsBase<Cr>
    nnoremap <leader>wB :CclsBaseHierarchy<Cr>
    nnoremap <leader>wd :CclsDerived<Cr>
    nnoremap <leader>wD :CclsDerivedHierarchy<Cr>
    nnoremap <leader>wc :CclsCallers<Cr>
    nnoremap <leader>wC :CclsCallHierarchy<Cr>
    nnoremap <leader>we :CclsCallees<Cr>
    nnoremap <leader>wE :CclsCalleeHierarchy<Cr>
    xnoremap <leader>wv :CclsVars<Cr>

    nnoremap <leader>Wb :CclsMembers<Cr>
    nnoremap <leader>Wh :CclsMemberHierarchy<Cr>
    nnoremap <leader>Wf :CclsMemberFunctions<Cr>
    nnoremap <leader>WF :CclsMemberFunctionHierarchy<Cr>
    nnoremap <leader>Wt :CclsMemberTypes<Cr>
    nnoremap <leader>WT :CclsMemberTypeHierarchy<Cr>
endif

nmap <leader>Ws :IHS<CR>
nmap <leader>WS :IHS<CR>:A<CR>
nmap <leader>WH :IHN<CR>
