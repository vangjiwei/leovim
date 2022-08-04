set commentstring=//\ %s
" cpp-mode
if Installed('cpp-mode')
    nnoremap \y :CopyCode<cr>
    nnoremap \p :PasteCode<cr>
    nnoremap \g :GoToFunImpl<cr>
    nnoremap \s :Switch<cr>
    nnoremap \f :FormatFunParam<cr>
    nnoremap \i :FormatIf<cr>
    nnoremap \t :GenTryCatch<cr>
    xnoremap \t :GenTryCatch<cr>
endif
" ccls
if Installed('vim-ccls')
    nnoremap \l  :Ccls<Tab>
    nnoremap \b  :CclsBase<Cr>
    nnoremap \hb :CclsBaseHierarchy<Cr>
    nnoremap \d  :CclsDerived<Cr>
    nnoremap \hd :CclsDerivedHierarchy<Cr>
    nnoremap \c  :CclsCallers<Cr>
    nnoremap \hc :CclsCallHierarchy<Cr>
    nnoremap \e  :CclsCallees<Cr>
    nnoremap \he :CclsCalleeHierarchy<Cr>
    xnoremap \v  :CclsVars<Cr>
    nnoremap \mm :CclsMembers<Cr>
    nnoremap \hm :CclsMemberHierarchy<Cr>
    nnoremap \mf :CclsMemberFunctions<Cr>
    nnoremap \hf :CclsMemberFunctionHierarchy<Cr>
    nnoremap \mt :CclsMemberTypes<Cr>
    nnoremap \ht :CclsMemberTypeHierarchy<Cr>
endif
