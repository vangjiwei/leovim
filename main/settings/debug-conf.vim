" --------------------------
" repl
" --------------------------
if g:has_terminal
    imap <M-e> # %%
    imap <M-y> # %% STEP
endif
if Installed('sniprun')
    luafile $LUA_PATH/sniprun-config.lua
    nmap cs <Plug>SnipRunOperator
    nmap <leader>rs :Snip
    nmap <silent><leader>r<Cr>    vaB:SnipRun<Cr>gv<Esc><Down>
    xmap <silent><leader>r<Cr>    :SnipRun<Cr>gv<Esc><Down>
    nmap <silent><leader>r<space> :SnipClose<Cr>
    nmap <silent><leader>rn :SnipRun<Cr><Down>
    xmap <silent><leader>rn :SnipRun<Cr>gv<Esc><Down>
    nmap <silent><leader>ri :SnipInfo<Cr>
    nmap <silent><leader>ro :SnipReset<Cr>
    nmap <silent>\C  Vgg:SnipRun<Cr><C-o>
    nmap <silent>\R  ggVG:SnipRun<Cr><C-o>
endif
if Installed('iron.nvim')
    luafile $LUA_PATH/iron-config.lua
    nmap co :IronRepl<Cr>
    nmap cO :IronRestart<Cr>
    nmap cn cl<Down>
    " extend
    nmap cf :IronFocus<Cr>
    nmap \I :Iron<Tab>
    nmap \W :IronWatch<Space>
    " sent block
    nmap c<Cr> viBcl<Esc><Down><Down>
    xmap c<Cr> cl<ESC><Down>
    xmap cn    cl<ESC><Down>
    nmap <leader>C Vggcl<ESC><C-o>
    nmap <leader>E VGcl<ESC><C-o>
elseif Installed("vim-repl")
    let g:repl_program = {}
    let g:repl_program.python = []
    if executable('ipython')
        let g:repl_program.python += ['ipython']
    endif
    if UNIX() && executable('ptpython')
        let g:repl_program.python += ['ptpython']
    endif
    if executable('python3')
        let g:repl_program.python += ['python3']
    endif
    let g:repl_program.python += ['python']
    " map
    au Filetype python,sh,perl,javascript,lua call s:set_repl_map()
    function! s:set_repl_map()
        nmap \R :REPL
        nmap co :REPLToggle<Cr>
        nmap c<Cr> vaBcn
        xmap c<Cr> cn
        nmap cl cnk
        xmap cl cngvo
        nmap <leader>C Vggcn<C-o>
        nmap <leader>E VGcn<C-o>
        nmap <leader>R ggVGcn<C-o><C-o>
    endfunction
    au Filetype python call s:set_ipdb_map()
    function! s:set_ipdb_map() abort
        nnoremap \C :REPLDebugStopAtCurrentLine<Cr>
        nnoremap \c :<C-u>REPLPDBC<Cr>
        nnoremap \n :<C-u>REPLPDBN<Cr>
        nnoremap \s :<C-u>REPLPDBS<Cr>
        nnoremap \u :<C-u>REPLPDBU<Cr>
    endf
endif
" --------------------------
" debug
" --------------------------
if Installed('nvim-dap') && Installed('nvim-dap-ui') && Installed('mason.nvim')
    let g:debug_tool = 'nvim-dap'
    luafile $LUA_PATH/nvim-dap-ui.lua
    " dap adapter is installed handly
    nnoremap ,o :tabe ~/.leovim.conf/nvim-dap/dap.example.lua<Cr>:e ~/.leovim.d/dap.lua<Cr>
    if filereadable(expand("~/.leovim.d/dap.lua") )
        luafile ~/.leovim.d/dap.lua
    endif
    " basic
    nnoremap ,dd :lua require("dap").
    " close
    nnoremap ,dq <cmd>lua require("dap").close()<Cr>
    nnoremap <silent> ,c <cmd>lua require("dap").continue()<CR>
    nnoremap <silent> ,C <cmd>lua require("dap").run_to_cursor()<CR>
    nnoremap <silent> ,R <cmd>lua require("dap").run_last()<CR>
    nnoremap <silent> ,n <cmd>lua require("dap").step_over()<CR>
    nnoremap <silent> ,s <cmd>lua require("dap").step_into()<CR>
    nnoremap <silent> ,u <cmd>lua require("dap").step_out()<CR>
    nnoremap <silent> ,U <cmd>lua require("dap").step_back()<CR>
    nnoremap <silent> ,a <cmd>lua require("dap").attach(vim.fn.input('Attatch to: '))<CR>
    " hover
    nnoremap <silent> ,h <cmd>lua require("dap.ui.variables").hover()<CR>
    xnoremap <silent> ,h <cmd>lua require("dap.ui.variables").visual_hover()<CR>
    nnoremap <silent> ,w <cmd>lua require("dap.ui.widgets").hover()<CR>
    " view
    nnoremap <silent> ,i <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.scopes)<CR>
    nnoremap <silent> ,I <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.frames)<CR>
    " breakpoint
    nnoremap <silent> ,b <cmd>lua require("dap").toggle_breakpoint()<CR>
    nnoremap <silent> ,B <cmd>lua require("dap").toggle_breakpoint({"all"})<CR>
    nnoremap <silent> ,l <cmd>lua require("dap").list_breakpoints("")<Cr>
    nnoremap <silent> <M-u>s <cmd>lua require("dap").set_exception_breakpoints("")<left><left>
    nnoremap <silent> <M-u>l <cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input('Breakpoints log: '))<CR>
    nnoremap <silent> <M-u>b <cmd>lua require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    " debug
    nnoremap <silent> <M-u>q <cmd>lua require("dap").disconnect({ terminateDebuggee = true });require"dap".close()<CR>
    nnoremap <silent> <M-u>u <cmd>lua require("dap").up()<Cr>
    nnoremap <silent> <M-u>d <cmd>lua require("dap").down()<Cr>
    nnoremap <silent> <M-u>p <cmd>lua require("dap").pause()<Cr>
    nnoremap <silent> <M-u>g <cmd>lua require("dap").launch(vim.fn.input('Get config: '))<Cr>
    " repl
    nnoremap <silent> <M-u>o <cmd>lua require("dap").repl.open({}, 'vsplit')<CR>
    nnoremap <silent> <M-u>c <cmd>lua require("dap").repl.close()<CR>
    " autocomplete
    au FileType dap-repl lua require('dap.ext.autocompl').attach()
    " --------------------------------------
    " nvim-dap-ui
    " ---------------------------------------
    nnoremap ,du :lua require("dapui").
    nnoremap <silent> ,r <cmd>lua require("dapui").toggle()<CR>
    " watch
    nnoremap <silent> ,e <cmd>lua require("dapui").eval()<CR>
    nnoremap <silent> <M-m>f <cmd>lua require("dapui").float_element()<Cr>
    nnoremap <silent> <M-m>b <cmd>lua require("dapui").float_element('breakpoints')<Cr>
    nnoremap <silent> <M-m>s <cmd>lua require("dapui").float_element('stacks')<Cr>
    nnoremap <silent> <M-m>w <cmd>lua require("dapui").float_element('watches')<Cr>
    nnoremap <silent> <M-m>r <cmd>lua require("dapui").float_element('repl')<Cr>
    " jump to windows in dapui
    nnoremap <M-m>1 :call GoToDAPWindows("DAP Scopes")<Cr>
    nnoremap <M-m>2 :call GoToDAPWindows("DAP Breakpoints")<Cr>
    nnoremap <M-m>3 :call GoToDAPWindows("DAP Stacks")<Cr>
    nnoremap <M-m>4 :call GoToDAPWindows("DAP Watches")<Cr>
    nnoremap <M-m>5 :call GoToDAPWindows("[dap-repl]")<Cr>
    nnoremap <M-m>6 :call GoToDAPWindows("")<Cr>
    function! GoToDAPWindows(name) abort
        let windowNr = 0
        let name = a:name
        try
            let windowNr = bufwinnr(name)
        catch
            let windowNr = 0
        endtry
        if windowNr > 0
            execute windowNr . 'wincmd w'
        endif
    endfunction
    " ---------------------------------------
    " nvim-dap-python
    " ---------------------------------------
    if Installed('nvim-dap-python')
        nnoremap <silent> ,dm <cmd>lua require('dap-python').test_method()<CR>
        nnoremap <silent> ,dc <cmd>lua require('dap-python').test_class()<CR>
        vnoremap <silent> ,dv <ESC><cmd>lua require('dap-python').debug_selection()<CR>
    endif
elseif Installed('vimspector')
    let g:debug_tool = "vimspector"
    let g:vimspector_enable_mappings = 'HUMAN'
    " load template
    function! s:read_template(template)
        execute '0r ' . $LEOVIM_PATH . '/vimspector/' . a:template
    endfunction
    if WINDOWS()
        command! -bang -nargs=* LoadVimspectorJsonTemplate call fzf#run(extend(g:fzf_layout, {
                    \ 'source': 'dir /b /a-d ' . $LEOVIM_PATH . '\\vimspector',
                    \ 'sink': function('<sid>read_template')
                    \ }))
    else
        command! -bang -nargs=* LoadVimspectorJsonTemplate call fzf#run(extend(g:fzf_layout, {
                    \ 'source': 'ls -1 ' . $LEOVIM_PATH . '/vimspector',
                    \ 'sink': function('<sid>read_template')
                    \ }))
    endif
    nnoremap ,o :tabe ../.vimspector.json<Cr>:LoadVimspectorJsonTemplate<Cr>
    " core shortcuts
    nnoremap ,v :Vimspector<Tab>
    nnoremap ,e :VimspectorEval<Space>
    nnoremap ,w :VimspectorWatch<Space>
    nnoremap ,W :call vimspector#DeleteWatch()<Cr>
    nnoremap ,a :call vimspector#AddWatch("")<Left><Left>
    " run
    nmap <silent> ,c <Plug>VimspectorContinue
    nmap <silent> ,C <Plug>VimspectorRunToCursor
    nmap <silent> ,n <Plug>VimspectorStepOver
    nmap <silent> ,s <Plug>VimspectorStepInto
    nmap <silent> ,u <Plug>VimspectorStepOut
    nmap <silent> ,r :call vimspector#Reset()<Cr>
    nmap <silent> ,R :call vimspector#Restart()<Cr>
    " breakpoint
    nmap <silent> ,b <Plug>VimspectorToggleBreakpoint
    nmap <silent> ,B :call vimspector#ClearBreakpoints()<Cr>
    nmap <silent> ,l :call vimspector#ListBreakpoints()<Cr>
    " debug
    nmap <silent> <M-u>u :call vimspector#UpFrame()<Cr>
    nmap <silent> <M-u>d :call vimspector#DownFrame()<Cr>
    nmap <silent> <M-u>b <Plug>VimspectorBalloonEval
    nmap <silent> <M-u>f <Plug>VimspectorAddFunctionBreakpoint
    nmap <silent> <M-u>c <Plug>VimspectorToggleConditionalBreakpoint
    nmap <silent> <F7>   <Plug>VimspectorToggleConditionalBreakpoint
    " other commands
    nnoremap ,di :VimspectorInstall <Tab>
    nnoremap ,dv :call vimspector#<Tab>
    nnoremap ,dg :call vimspector#GetConfigurations()<Cr>
    nnoremap ,dp :call vimspector#Pause()<Cr>
    nnoremap ,dt :call vimspector#SetCurrentThread()<Cr>
    nnoremap ,de :call vimspector#ExpandVariable()<Cr>
    nnoremap ,dq :call vimspector#Stop()<Cr>
    nnoremap ,dl :call vimspector#Launch()<Cr>
    " jump to windows in vimspector
    nnoremap <M-m>o :call GoToVimspectorWindow('output')<Cr>
    nnoremap <M-m>e :call GoToVimspectorWindow('stderr')<Cr>
    nnoremap <M-m>s :call GoToVimspectorWindow('server')<Cr>
    nnoremap <M-m>c :call GoToVimspectorWindow('Console')<Cr>
    nnoremap <M-m>t :call GoToVimspectorWindow('Telemetry')<Cr>
    nnoremap <M-m>v :call GoToVimspectorWindow('Vimspector')<Cr>
    nnoremap <M-m>1 :call GoToVimspectorWindow('variables')<Cr>
    nnoremap <M-m>2 :call GoToVimspectorWindow('watches')<Cr>
    nnoremap <M-m>3 :call GoToVimspectorWindow('stacktrace')<Cr>
    nnoremap <M-m>4 :call GoToVimspectorWindow('code')<Cr>
    nnoremap <M-m>5 :call GoToVimspectorWindow('terminal')<Cr>
    function! GoToVimspectorWindow(name) abort
        let windowNr = 0
        let name = a:name
        try
            if name ==# 'variables'
                let windowNr = bufwinnr('vimspector.Variables')
            elseif name ==# 'watches'
                let windowNr = bufwinnr('vimspector.Watches')
            elseif name ==# 'stacktrace'
                let windowNr = bufwinnr('vimspector.StackTrace')
            elseif name ==# 'terminal' || name ==# 'code'
                let windowNr = bufwinnr(winbufnr(g:vimspector_session_windows[name]))
            else
                call vimspector#ShowOutput(name)
            endif
        catch
            " pass
        endtry
        if windowNr > 0
            execute windowNr . 'wincmd w'
        endif
    endfunction
elseif get(g:, 'debug_tool', '') == 'termdebug'
    let g:termdebug_map_K = 0
    let g:termdebug_use_prompt = 1
    " breakpoint
    nnoremap ,b :Break<Cr>
    nnoremap ,B :Clear<Cr>
    " debug
    nnoremap ,d :Termdebug
    nnoremap ,D :TermdebugCommand<Space>
    nnoremap ,c :Continue<Cr>
    nnoremap ,n :Over<Cr>
    nnoremap ,s :Step<Cr>
    nnoremap ,u :Finish<Cr>
    nnoremap ,a :Arguments<Space>
    nnoremap ,e :Evaluate<Space>
    nnoremap ,R :Run<Space>
    nnoremap <M-u>p :Program<Cr>
    nnoremap <M-u>o :Source<Cr>
    nnoremap <M-u>g :Gdb<Cr>
    nnoremap <M-u>a :Asm<Cr>
endif
