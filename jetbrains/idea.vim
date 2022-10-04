source ~/.leovim.conf/main/set.vim
source ~/.leovim.conf/main/map.vim
" idea smart join
set ideajoin
" jump between brackets
nnoremap <Cr> g%
xnoremap <Cr> g%
nnoremap <C-j> %
xnoremap <C-j> %
" Closing tabs
nnoremap <space>q :action CloseContent<cr>
nnoremap <space>o :action ReopenClosedTab<cr>
" To navigate between split panes
nnoremap <A-]> :action NextSplitter<cr>
nnoremap <A-[> :action PrevSplitter<cr>
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
" Search
nnoremap <space>/  :action Find<cr>
nnoremap <space>ff :action FindInPath<cr>
nnoremap <space>fp :action ShowFilePath<cr>
nnoremap <space>fr :action RenameFile<CR>
nnoremap s/        :action SearchEverywhere<CR>
" Navigation
nnoremap K       :action ShowPopupMenu<Cr>
nnoremap <A-;>   :action ShowUsages<cr>
nnoremap <A-S-;> :action FindUsages<cr>
nnoremap gd :action GotoDefinition<cr>
nnoremap gh :action GotoTypeDeclaration<cr>
nnoremap gl :action GotoDeclaration<cr>
nnoremap gm :action GotoImplementation<cr>
nnoremap ga :action GotoAction<CR>
nnoremap gf :action GotoFile<cr>
nnoremap gc :action GotoClass<cr>
nnoremap gt :action GotoTest<cr>
nnoremap gi :action JumpToLastChange<CR>
" method
nnoremap gs :action SuperMethod<cr>
nnoremap [m :action MethodUp<cr>
nnoremap ]m :action MethodDown<cr>
" symbol
nnoremap f<cr>   :action FileStructurePopup<cr>
nnoremap <A-/>   :action StructureViewPopupMenu<cr>
nnoremap <A-S-/> :action GotoSymbol<cr>
nnoremap <A-\>   :action NavBarToolBar<cr>
nnoremap <A-S-\> :action ShowBookmarks<cr>
" action back/forword
nnoremap <A-S-,> :action Back<CR>
nnoremap <A-S-.> :action Forward<CR>
" Terminal
nnoremap <A--> :action ActivateTerminalToolWindow<cr>
" maven
nnoremap <space>am :action ActivateMavenProjectsToolWindow<CR>
" Errors
nnoremap <space>ad :action ShowErrorDescription<cr>
nnoremap <space>at :action AnalyzeStacktraceOnError<Cr>
nnoremap <space>e  :action GoToErrorGroup<Cr>
nnoremap ]e :action GotoNextError <CR>
nnoremap [e :action GotoPreviousError<CR>
" recentfiles
nnoremap <space>m :action RecentFiles<CR>
" VCS operations
nnoremap <space>gs :action Vcs.Show.Local.Changes<cr>
nnoremap <space>gp :action Vcs.QuickListPopupAction<cr>
nnoremap <space>ga :action Annotate<cr>
nnoremap <space>gl :action Vcs.Show.Log<cr>
nnoremap <space>gc :action Compare.LastVersion<cr>
nnoremap <space>gr :action Git.ResolveConflicts<cr>
nnoremap [c :action VcsShowPrevChangeMarker<cr>
nnoremap ]c :action VcsShowNextChangeMarker<cr>
" breakpoints Build
nnoremap <A-'>    :action ToggleLineBreakpoint<cr>
nnoremap <space>l :action ViewBreakpoints<cr>
nnoremap <space>cd :action CompileDirty<cr>
" comments
" Use default map of <c-/> for that.
nnoremap <space>cc :action CommentByLineComment<cr>
" run
nnoremap <space>rr :action Run<cr>
nnoremap <space>re :action RenameElement<CR>
nnoremap <space>cf :action ChooseRunConfiguration<CR>
nnoremap <space>R  :action RunAnything<cr>
nnoremap <space>C  :action RunClass<cr>
nnoremap <space>T  :action RerunTests<cr>
" debug
nnoremap <space>dd :action Debug<cr>
nnoremap <space>dc :action DebugClass<cr>
nnoremap <space>cd :action ChooseDebugConfiguration<CR>
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
nnoremap <C-n> <Plug>NextWholeOccurrence
xnoremap <C-n> <Plug>NextWholeOccurrence
nnoremap <C-k> <Plug>SkipOccurrence
xnoremap <C-k> <Plug>SkipOccurrence
nnoremap <C-h> <Plug>RemoveOccurrence
xnoremap <C-h> <Plug>RemoveOccurrence
nnoremap ]o <Plug>NextOccurrence
xnoremap ]o <Plug>NextOccurrence
nnoremap [o <Plug>PreviousOccurrence
xnoremap [o <Plug>PreviousOccurrence
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
