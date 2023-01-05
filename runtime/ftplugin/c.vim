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
    xnoremap <leader>wv :CclsVars<Cr>
    nnoremap <leader>wb :CclsBase<Cr>
    nnoremap <leader>wB :CclsBaseHierarchy<Cr>
    nnoremap <leader>wd :CclsDerived<Cr>
    nnoremap <leader>wD :CclsDerivedHierarchy<Cr>
    nnoremap <leader>wc :CclsCallers<Cr>
    nnoremap <leader>wC :CclsCallHierarchy<Cr>
    nnoremap <leader>we :CclsCallees<Cr>
    nnoremap <leader>wE :CclsCalleeHierarchy<Cr>
    " CclsMembers
    nnoremap <leader>Wb :CclsMembers<Cr>
    nnoremap <leader>Wh :CclsMemberHierarchy<Cr>
    nnoremap <leader>Wf :CclsMemberFunctions<Cr>
    nnoremap <leader>WF :CclsMemberFunctionHierarchy<Cr>
    nnoremap <leader>Wt :CclsMemberTypes<Cr>
    nnoremap <leader>WT :CclsMemberTypeHierarchy<Cr>
endif
" for a.vim
if Installed('a.vim')
    nnoremap <leader>ph :A<Cr>
    nnoremap <leader>ps :AS<Cr>
    nnoremap <leader>pv :AV<Cr>
    nnoremap <leader>pt :AT<Cr>
    nnoremap <leader>pn :AN<Cr>
    nnoremap <leader>pih :IH<Cr>
    nnoremap <leader>pis :IHS<Cr>
    nnoremap <leader>piv :IHV<Cr>
    nnoremap <leader>pit :IHT<Cr>
    nnoremap <leader>pin :IHN<Cr>
endif
