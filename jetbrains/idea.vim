source ~/.leovim.conf/main/set.vim
source ~/.leovim.conf/main/map.vim
" idea smart join
set ideajoin

" action forword back
nnoremap <BS>   :action Back<CR>
nnoremap <C-BS> :action Forward<CR>
" jump between brackets
nmap <Cr> g%
xmap <Cr> g%
nmap <C-j> %
xmap <C-j> %
" Closing tabs
nmap <space>q :action CloseContent<cr>
nmap <space>o :action ReopenClosedTab<cr>

" To navigate between split panes
nmap <A-]> :action NextSplitter<cr>
nmap <A-[> :action PrevSplitter<cr>

" Tabs
nnoremap <Tab>p :action PreviousTab<cr>
nnoremap <Tab>n :action NextTab<cr>
nnoremap <Tab>h <C-w>h
nnoremap <Tab>j <C-w>j
nnoremap <Tab>k <C-w>k
nnoremap <Tab>l <C-w>l
nnoremap <Tab>H <C-w>H
nnoremap <Tab>J <C-w>J
nnoremap <Tab>K <C-w>K
nnoremap <Tab>L <C-w>L
" Splits manipulation
nnoremap <Tab>s :action SplitHorizontally<cr>
nnoremap <Tab>v :action SplitVertically<cr>
" tab
nnoremap <Tab><Tab> <C-i>
xnoremap <Tab><Tab> <C-i>
nnoremap <C-l> <C-i>
xnoremap <C-l> <C-i>

" Search
nmap <space>/  :action Find<cr>
nmap <space>ff :action FindInPath<cr>

" Navigation
nnoremap <C-]>   :action GotoDefinition<cr>
nnoremap <A-,>   :action GotoTypeDeclaration<cr>
nnoremap <A-.>   :action GotoDeclaration<cr>
nnoremap <A-S-;> :action GotoImplementation<cr>
nnoremap f<cr> :action FileStructurePopup<cr>
nnoremap t<cr> :action StructureViewPopupMenu<cr>
nnoremap K     :action FindUsages<cr>
nnoremap <A-;>   :action ShowPopupMenu<Cr>
nnoremap <A-/>   :action ShowUsages<cr>
nnoremap <A-S-/> :action GotoSymbol<cr>
nnoremap <A-\>   :action NavBarToolBar<cr>
nnoremap <A-S-\> :action ShowBookmarks<cr>
nnoremap ga :action GotoAction<CR>
nnoremap gf :action GotoFile<cr>
nnoremap gc :action GotoClass<cr>
nnoremap gt :action GotoTest<cr>
nnoremap gl :action JumpToLastChange<CR>
nnoremap gs :action SuperMethod<cr>
nnoremap gr :action RecentFiles<CR>
nnoremap <A-S-,> :action Back<CR>
nnoremap <A-S-.> :action Forward<CR>

" Terminal
nnoremap <A--> :action ActivateTerminalToolWindow<cr>
" Errors
nnoremap g<tab>   :action ShowErrorDescription<cr>
nnoremap g<cr>    :action AnalyzeStacktraceOnError<Cr>
nnoremap <space>d :action GoToErrorGroup<Cr>
nnoremap ]d :action GotoNextError <CR>
nnoremap [d :action GotoPreviousError<CR>
" VCS operations
nmap <space>gs :action Vcs.Show.Local.Changes<cr>
nmap <space>gp :action Vcs.QuickListPopupAction<cr>
nmap <space>ga :action Annotate<cr>
nmap <space>gl :action Vcs.Show.Log<cr>
nmap <space>gc :action Compare.LastVersion<cr>
nmap <space>gr :action Git.ResolveConflicts<cr>
" Won't work in visual mode (with vmap) for some reason.
" Use default map of <c-/> for that.
" nmap <space>cc :action CommentByLineComment<cr>
" unimpaired mappings - from https://github.com/saaguero/ideavimrc/blob/master/.ideavimrc
nnoremap [m :action MethodUp<cr>
nnoremap ]m :action MethodDown<cr>
nnoremap [c :action VcsShowPrevChangeMarker<cr>
nnoremap ]c :action VcsShowNextChangeMarker<cr>

" Building, Running and Debugging
nmap \b       :action ToggleLineBreakpoint<cr>
nmap <space>c :action CompileDirty<cr>
nmap <space>r :action Run<cr>
nmap <space>R :action RunAnything<cr>
nmap <space>b :action Debug<cr>
nmap <space>e :action DebugClass<cr>
nmap <space>C :action RunClass<cr>
nmap <space>R :action RerunTests<cr>
nmap <space>T :action RerunFailedTests<cr>

" Clojure specific mappings for Cursive
nmap \c :action :cursive.repl.actions/clear-repl<cr>
nmap \l :action :cursive.repl.actions/load-file<cr>
nmap \o :action :cursive.repl.actions/jump-to-output<cr>
nmap \r :action :cursive.repl.actions/jump-to-repl<cr>
nmap \t :action :cursive.testing.actions/run-ns-tests<cr>
nmap \T :action :cursive.testing.actions/rerun-last-test<cr>
nmap \C :action :cursive.testing.actions/remove-test-markers<cr>

" =========================================
" Emulated Plugins
" =========================================
set surround
nnoremap <Space>st :action SurroundWith<CR>
xnoremap <Space>st :<c-u>action SurroundWith<CR>
nnoremap <Space>se :action SurroundWithEmmet<CR>
xnoremap <Space>se :<c-u>action SurroundWithEmmet<CR>
nnoremap <Space>sl :action SurroundWithLiveTemplate<CR>
xnoremap <Space>sl :<c-u>action SurroundWithLiveTemplate<CR>
" Multiple cursors support
set multiple-cursors
nmap <C-n> <Plug>NextWholeOccurrence
xmap <C-n> <Plug>NextWholeOccurrence
nmap <C-k> <Plug>SkipOccurrence
xmap <C-k> <Plug>SkipOccurrence
nmap <C-h> <Plug>RemoveOccurrence
xmap <C-h> <Plug>RemoveOccurrence
nmap ]o <Plug>NextOccurrence
xmap ]o <Plug>NextOccurrence
nmap [o <Plug>PreviousOccurrence
xmap [o <Plug>PreviousOccurrence
" easymotion
set easymotion
source ~/.leovim.conf/main/settings/easymotion.vim
" which-key
set which-key
set notimeout
set timeoutlen=500
" set input switch
set keep-english-in-normal-and-restore-in-insert
" other extensions
set match.it
set argtextobj.vim
set vim-textobj-entire
set ReplaceWithRegister
set vim-highlightedyank
