set commentstring=//\ %s
" cpp-mode
if Installed('cpp-mode')
    nnoremap <M-h>y :CopyCode<cr>
    nnoremap <M-h>p :PasteCode<cr>
    nnoremap <M-h>g :GoToFunImpl<cr>
    nnoremap <M-h>s :Switch<cr>
    nnoremap <M-h>f :FormatFunParam<cr>
    nnoremap <M-h>i :FormatIf<cr>
    nnoremap <M-h>t :GenTryCatch<cr>
    xnoremap <M-h>t :GenTryCatch<cr>
endif
" ccls
if Installed('vim-ccls')
    nnoremap <M-h>l :Ccls<Tab>
    nnoremap <M-h>b :CclsBase<Cr>
    nnoremap <M-h>B :CclsBaseHierarchy<Cr>
    nnoremap <M-h>d :CclsDerived<Cr>
    nnoremap <M-h>D :CclsDerivedHierarchy<Cr>
    nnoremap <M-h>c :CclsCallers<Cr>
    nnoremap <M-h>C :CclsCallHierarchy<Cr>
    nnoremap <M-h>e :CclsCallees<Cr>
    nnoremap <M-h>E :CclsCalleeHierarchy<Cr>
    xnoremap <M-h>v :CclsVars<Cr>
    nnoremap <M-h>mb :CclsMembers<Cr>
    nnoremap <M-h>Mb :CclsMemberHierarchy<Cr>
    nnoremap <M-h>mf :CclsMemberFunctions<Cr>
    nnoremap <M-h>Mf :CclsMemberFunctionHierarchy<Cr>
    nnoremap <M-h>mt :CclsMemberTypes<Cr>
    nnoremap <M-h>Mt :CclsMemberTypeHierarchy<Cr>
endif
