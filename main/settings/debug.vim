" --------------------------
" repl
" --------------------------
imap <M-e> # %%
imap <M-t> # %%STEP
if Installed('iron.nvim')
    if Installed('sniprun')
        luafile $LUA_PATH/sniprun.lua
        nmap cs <Plug>SnipRunOperator
        nmap <leader>rs :Snip
        nmap <silent><leader>r<Cr> vaB:SnipRun<Cr>gv<Esc><Down>
        xmap <silent><leader>r<Cr> :SnipRun<Cr>gv<Esc><Down>
        nmap <silent><leader>r<space> :SnipClose<Cr>
        nmap <silent><leader>rn :SnipRun<Cr><Down>
        xmap <silent><leader>rn :SnipRun<Cr>gv<Esc><Down>
        nmap <silent><leader>ri :SnipInfo<Cr>
        nmap <silent><leader>rR :SnipReset<Cr>
        nmap <silent>\C  Vgg:SnipRun<Cr><C-o>
        nmap <silent>\S  ggVG:SnipRun<Cr><C-o>
    endif
    luafile $LUA_PATH/iron.lua
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
    elseif executable('python')
        let g:repl_program.python += ['python']
    endif
    if executable('Rscript')
        if executable('radian')
            let g:repl_program.r = ['radian', 'R']
        else
            let g:repl_program.r = 'R'
        endif
    endif
    " map
    au Filetype python,sh,perl,javascript,lua,r call s:set_repl_map()
    function! s:set_repl_map()
        nmap \R :REPL
        nmap co :REPLToggle<Cr>
        nmap c<Cr> vaBcn
        xmap c<Cr> cn
        nmap cl cnk
        xmap cl cngvo
        nmap <leader>C Vggcn<C-o>
        nmap <leader>E VGcn<C-o>
        nmap <leader>S ggVGcn<C-o><C-o>
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
if Installed('nvim-dap', 'nvim-dap-ui')
    let g:debug_tool = 'nvim-dap'
    if get(g:, 'leovim_loaded', 0) == 0
        luafile $LUA_PATH/dap.lua
    endif
    nnoremap ,D :tabe ~/.leovim.conf/nvim-dap/dap.example.lua<Cr>:tabe ~/.leovim.conf/adapter.lua<Cr>
    if filereadable(expand("~/.leovim.conf/adapter.lua"))
        luafile ~/.leovim.conf/adapter.lua
    endif
    nnoremap ,d :lua require("dap").
    " basic
    nnoremap <silent> ,c <cmd>lua require("dap").run_to_cursor()<CR>
    nnoremap <silent> ,n <cmd>lua require("dap").continue()<CR>
    nnoremap <silent> ,s <cmd>lua require("dap").step_into()<CR>
    nnoremap <silent> ,S <cmd>lua require("dap").step_back()<CR>
    nnoremap <silent> ,o <cmd>lua require("dap").step_over()<CR>
    nnoremap <silent> ,u <cmd>lua require("dap").step_out()<CR>
    nnoremap <silent> ,q <cmd>lua require("dap").close()<Cr>
    nnoremap <silent> ,a <cmd>lua require("dap").attach(vim.fn.input('Attatch to: '))<CR>
    nnoremap <silent> ,p <cmd>lua require("dap").pause()<Cr>
    " view
    nnoremap <silent> ,w <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.scopes)<CR>
    nnoremap <silent> ,f <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.frames)<CR>
    nnoremap <silent> ,i <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.expression)<CR>
    " breakpoint
    nnoremap <silent> ,b <cmd>lua require("dap").toggle_breakpoint()<CR>
    nnoremap <silent> ,B <cmd>lua require("dap").clear_breakpoints()<CR>
    nnoremap <silent> ,l <cmd>lua require("dap").list_breakpoints()<Cr>
    nnoremap <silent> <M-d>i <cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input('Breakpoints info: '))<CR>
    nnoremap <silent> <M-d>e <cmd>lua require("dap").set_exception_breakpoints("")<left><left>
    nnoremap <silent> <M-d>b <cmd>lua require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    " debug
    nnoremap <silent> <M-d>D <cmd>lua require("dap").disconnect({ terminateDebuggee = true });require"dap".close()<CR>
    nnoremap <silent> <M-d>u <cmd>lua require("dap").up()<Cr>
    nnoremap <silent> <M-d>d <cmd>lua require("dap").down()<Cr>
    nnoremap <silent> <M-d>g <cmd>lua require("dap").launch(vim.fn.input('Get config: '))<Cr>
    " repl
    nnoremap <silent> <M-d>o <cmd>lua require("dap").repl.open({}, 'split')<CR>
    nnoremap <silent> <M-d>O <cmd>lua require("dap").repl.open({}, 'vsplit')<CR>
    nnoremap <silent> <M-d>c <cmd>lua require("dap").repl.close()<CR>
    " runlast
    nnoremap <silent> <M-d>r <cmd>lua require("dap").run_last()<CR>
    " auto attach
    au FileType dap-repl lua require('dap.ext.autocompl').attach()
    " --------------------------------------
    " nvim-dap-ui
    " ---------------------------------------
    nnoremap ,v :lua require("dapui").
    nnoremap <silent> ,r <cmd>lua require("dapui").toggle()<CR>
    " watch
    nnoremap <silent> ,e <cmd>lua require("dapui").eval()<CR>
    nnoremap <silent> <M-m>f <cmd>lua require("dapui").float_element()<Cr>
    nnoremap <silent> <M-m>r <cmd>lua require("dapui").float_element('repl')<Cr>
    nnoremap <silent> <M-m>b <cmd>lua require("dapui").float_element('breakpoints')<Cr>
    nnoremap <silent> <M-m>s <cmd>lua require("dapui").float_element('stacks')<Cr>
    nnoremap <silent> <M-m>c <cmd>lua require("dapui").float_element('console')<Cr>
    nnoremap <silent> <M-m>w <cmd>lua require("dapui").float_element('watches')<Cr>
    " jump to windows in dapui
    nnoremap <silent><M-m>1 :call GoToDAPWindows("DAP Scopes")<Cr>
    nnoremap <silent><M-m>2 :call GoToDAPWindows("DAP Watches")<Cr>
    nnoremap <silent><M-m>3 :call GoToDAPWindows("DAP Stacks")<Cr>
    nnoremap <silent><M-m>4 :call GoToDAPWindows("DAP Breakpoints")<Cr>
    nnoremap <silent><M-m>5 :call GoToDAPWindows("[dap-repl]")<Cr>
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
    nnoremap ,D :tabe ../.vimspector.json<Cr>:LoadVimspectorJsonTemplate<Cr>
    " core shortcuts
    nnoremap ,v :call vimspector#<Tab>
    nnoremap ,V :Vimspector<Tab>
    nnoremap ,e :VimspectorEval<Space>
    nnoremap ,w :VimspectorWatch<Space>
    nnoremap ,d :call vimspector#DeleteWatch()<Cr>
    nnoremap ,a :call vimspector#AddWatch("")<Left><Left>
    nnoremap ,q :call vimspector#Stop()<Cr>
    nnoremap ,r :call vimspector#Reset()<Cr>
    " run
    nmap <silent> ,c <Plug>VimspectorRunToCursor
    nmap <silent> ,n <Plug>VimspectorContinue
    nmap <silent> ,s <Plug>VimspectorStepInto
    nmap <silent> ,o <Plug>VimspectorStepOver
    nmap <silent> ,u <Plug>VimspectorStepOut
    " breakpoint
    nmap <silent> ,b <Plug>VimspectorToggleBreakpoint
    nmap <silent> ,B :call ToggleAllBreakpointsViewBreakpoint()<Cr>
    nmap <silent> ,l :call vimspector#ListBreakpoints()<Cr>
    " debug
    nmap <silent> ,p     :call vimspector#Pause()<Cr>
    nmap <silent> <M-d>u :call vimspector#UpFrame()<Cr>
    nmap <silent> <M-d>d :call vimspector#DownFrame()<Cr>
    nmap <silent> <M-d>b <Plug>VimspectorBalloonEval
    nmap <silent> <M-d>f <Plug>VimspectorAddFunctionBreakpoint
    nmap <silent> <M-d>c <Plug>VimspectorToggleConditionalBreakpoint
    nmap <silent> <F7>   <Plug>VimspectorToggleConditionalBreakpoint
    " other commands
    nnoremap <M-d>i :VimspectorInstall <Tab>
    nnoremap <M-d>g :call vimspector#GetConfigurations()<Cr>
    nnoremap <M-d>t :call vimspector#SetCurrentThread()<Cr>
    nnoremap <M-d>e :call vimspector#ExpandVariable()<Cr>
    nnoremap <M-d>r :call vimspector#Restart()<Cr>
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
elseif v:version >= 801 && !has('nvim') && Require('deubg') && executable('gdb')
    let g:debug_tool = 'termdebug'
    packadd termdebug
    let g:termdebug_map_K = 0
    let g:termdebug_use_prompt = 1
    " breakpoint
    nnoremap ,b :Break<Cr>
    nnoremap ,B :Clear<Cr>
    " debug
    nnoremap ,d :Termdebug
    nnoremap ,D :TermdebugCommand<Space>
    nnoremap ,n :Continue<Cr>
    nnoremap ,s :Step<Cr>
    nnoremap ,o :Over<Cr>
    nnoremap ,u :Finish<Cr>
    nnoremap ,r :Run<Space>
    nnoremap ,a :Arguments<Space>
    nnoremap ,e :Evaluate<Space>
    nnoremap <M-d>p :Program<Cr>
    nnoremap <M-d>o :Source<Cr>
    nnoremap <M-d>d :Gdb<Cr>
    nnoremap <M-d>a :Asm<Cr>
endif