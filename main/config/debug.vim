" --------------------------
" repl
" --------------------------
imap <M-e> # %%
imap <M-t> # %%STEP
if Installed('iron.nvim')
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
    nmap <leader>C Vggocl
    nmap <leader>E VGocl
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
        nmap <leader>C Vggocn
        nmap <leader>E VGocn
        nmap <leader>S :REPLSendAll<Cr>
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
nnoremap m <Nop>
if Installed('nvim-dap', 'nvim-dap-ui')
    let g:debug_tool = 'nvim-dap'
    if get(g:, 'leovim_loaded', 0) == 0
        luafile $LUA_PATH/dap.lua
    endif
    if InstalledTelescope()
        nnoremap m\ :tabe ~/.leovim.conf/adapter.lua<Cr>:lua require'telescope.builtin'.find_files({ cwd = '~/.leovim.conf/nvim-dap', prompt_title = 'nvim-dap-template' })<Cr>
    elseif InstalledFZF()
        " load template
        function! s:read_lua_template(template)
            execute '0r ' . $LEOVIM_PATH . '/nvim-data/' . a:template
        endfunction
        if WINDOWS()
            command! -bang -nargs=* LoadNvimDapTemplate call fzf#run(extend(g:fzf_layout, {
                        \ 'source': 'dir /b /a-d ' . $LEOVIM_PATH . '\\nvim-dap',
                        \ 'sink': function('<sid>read_lua_template')
                        \ }))
        else
            command! -bang -nargs=* LoadNvimDapTemplate call fzf#run(extend(g:fzf_layout, {
                        \ 'source': 'ls -1 ' . $LEOVIM_PATH . '/nvim-dap',
                        \ 'sink': function('<sid>read_lua_template')
                        \ }))
        endif
        nnoremap m\ :tabe  ~/.leovim.conf/adapter.lua<Cr>:LoadNvimDapTemplate<Cr>
    endif
    if filereadable(expand("~/.leovim.conf/adapter.lua"))
        luafile ~/.leovim.conf/adapter.lua
    endif
    nnoremap md :lua require("dap").
    " basic
    nnoremap <silent>mm <cmd>lua require("dap").continue()<CR>
    nnoremap <silent>mc <cmd>lua require("dap").run_to_cursor()<CR>
    nnoremap <silent>ms <cmd>lua require("dap").step_into()<CR>
    nnoremap <silent>mS <cmd>lua require("dap").step_back()<CR>
    nnoremap <silent>mo <cmd>lua require("dap").step_over()<CR>
    nnoremap <silent>mu <cmd>lua require("dap").step_out()<CR>
    nnoremap <silent>mq <cmd>lua require("dap").close()<Cr>
    nnoremap <silent>ma <cmd>lua require("dap").attach(vim.fn.input('Attatch to: '))<CR>
    nnoremap <silent>mp <cmd>lua require("dap").pause()<Cr>
    nnoremap <silent>mr <cmd>lua require("dap").run_last()<CR>
    nnoremap <silent>mR <cmd>lua require("dap").disconnect({ terminateDebuggee = true });require"dap".close()<CR>
    " view
    nnoremap <silent>mw <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.scopes)<CRupdate>
    nnoremap <silent>mf <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.frames)<CR>
    nnoremap <silent>mi <cmd>lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.expression)<CR>
    nnoremap <silent>mh <cmd>lua local widgets=require("dap.ui.widgets");widgets.hover()<CR>
    " breakpoint
    nnoremap <silent>mL <cmd>lua require("dap").clear_breakpoints()<CR>
    nnoremap <silent>mb <cmd>lua require("dap").toggle_breakpoint()<CR>
    nnoremap <silent>ml <cmd>lua require("dap").list_breakpoints()<Cr>
    nnoremap <silent><M-d>i <cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input('Breakpoints info: '))<CR>
    nnoremap <silent><M-d>e <cmd>lua require("dap").set_exception_breakpoints("")<left><left>
    nnoremap <silent><M-d>b <cmd>lua require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    " debug
    nnoremap <silent><M-d>u <cmd>lua require("dap").up()<Cr>
    nnoremap <silent><M-d>d <cmd>lua require("dap").down()<Cr>
    nnoremap <silent><M-d>g <cmd>lua require("dap").launch(vim.fn.input('Get config: '))<Cr>
    " repl
    nnoremap <silent><M-d>t <cmd>lua require("dap").repl.toggle()<CR>
    nnoremap <silent><M-d>s <cmd>lua require("dap").repl.open({}, 'split')<CR>
    nnoremap <silent><M-d>v <cmd>lua require("dap").repl.open({}, 'vsplit')<CR>
    " auto attach
    au FileType dap-repl lua require('dap.ext.autocompl').attach()
    " --------------------------------------
    " nvim-dap-ui
    " ---------------------------------------
    nnoremap mv :lua require("dapui").
    nnoremap <silent>mt <cmd>lua require("dapui").toggle()<CR>
    " watch
    nnoremap <silent>me <cmd>lua require("dapui").eval()<CR>
    nnoremap <silent><M-m>f <cmd>lua require("dapui").float_element()<Cr>
    nnoremap <silent><M-m>r <cmd>lua require("dapui").float_element('repl')<Cr>
    nnoremap <silent><M-m>b <cmd>lua require("dapui").float_element('breakpoints')<Cr>
    nnoremap <silent><M-m>s <cmd>lua require("dapui").float_element('stacks')<Cr>
    nnoremap <silent><M-m>c <cmd>lua require("dapui").float_element('console')<Cr>
    nnoremap <silent><M-m>w <cmd>lua require("dapui").float_element('watches')<Cr>
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
    " load template
    function! s:read_template(template)
        execute '0r ' . $LEOVIM_PATH . '/vimspector/' . a:template
    endfunction
    let g:debug_tool = "vimspector"
    let g:vimspector_enable_mappings = 'HUMAN'
    if WINDOWS()
        let g:vimspector_base_dir = $NVIM_DATA_PATH . "\\vimspector"
    else
        let g:vimspector_base_dir = $NVIM_DATA_PATH . "/vimspector"
    endif
    if InstalledFZF()
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
        nnoremap m\ :tabe ../.vimspector.json<Cr>:LoadVimspectorJsonTemplate<Cr>
    elseif InstalledTelescope()
        nnoremap m\ :tabe ../.vimspector.json<Cr>:lua require'telescope.builtin'.find_files({ cwd = '~/.leovim.conf/vimspector', prompt_title = 'vimspector-template' })<Cr>
    endif
    " core shortcuts
    nnoremap mv :call vimspector#
    nnoremap md :Vimspector
    nnoremap me :VimspectorEval<Space>
    nnoremap mw :VimspectorWatch<Space>
    nnoremap ma :call vimspector#AddWatch("")<Left><Left>
    nnoremap mp :call vimspector#Pause()<Cr>
    nmap <silent>mE <Plug>VimspectorBalloonEval
    " run
    nmap <silent>mc <Plug>VimspectorRunToCursor
    nmap <silent>mm <Plug>VimspectorContinue
    nmap <silent>ms <Plug>VimspectorStepInto
    nmap <silent>mo <Plug>VimspectorStepOver
    nmap <silent>mu <Plug>VimspectorStepOut
    " breakpoint
    nmap <silent>mb <Plug>VimspectorToggleBreakpoint
    nmap <silent>mB :call vimspector#ToggleAllBreakpointsViewBreakpoint()<Cr>
    nmap <silent>ml :call vimspector#ListBreakpoints()<Cr>
    nmap <silent><M-d>f <Plug>VimspectorAddFunctionBreakpoint
    nmap <silent><M-d>c <Plug>VimspectorToggleConditionalBreakpoint
    nmap <silent><F7>   <Plug>VimspectorToggleConditionalBreakpoint
    " del / stop
    nnoremap <silent>mx :call vimspector#DeleteWatch()<Cr>
    nnoremap <silent>mq :call vimspector#Stop()<Cr>
    nnoremap <silent>mR :call vimspector#Reset()<Cr>
    nnoremap <silent>mr :call vimspector#Restart()<Cr>
    " important functions
    nnoremap <silent><M-d>u :call vimspector#UpFrame()<Cr>
    nnoremap <silent><M-d>d :call vimspector#DownFrame()<Cr>
    " other commands
    nnoremap <M-d>i :VimspectorInstall<Space>
    nnoremap <silent><M-d>g :call vimspector#GetConfigurations()<Cr>
    nnoremap <silent><M-d>c :call vimspector#SetCurrentThread()<Cr>
    nnoremap <silent><M-d>e :call vimspector#ExpandVariable()<Cr>
    " jump to windows in vimspector
    nnoremap <silent><M-m>o :call GoToVimspectorWindow('output')<Cr>
    nnoremap <silent><M-m>e :call GoToVimspectorWindow('stderr')<Cr>
    nnoremap <silent><M-m>s :call GoToVimspectorWindow('server')<Cr>
    nnoremap <silent><M-m>c :call GoToVimspectorWindow('Console')<Cr>
    nnoremap <silent><M-m>t :call GoToVimspectorWindow('Telemetry')<Cr>
    nnoremap <silent><M-m>v :call GoToVimspectorWindow('Vimspector')<Cr>
    nnoremap <silent><M-m>1 :call GoToVimspectorWindow('variables')<Cr>
    nnoremap <silent><M-m>2 :call GoToVimspectorWindow('watches')<Cr>
    nnoremap <silent><M-m>3 :call GoToVimspectorWindow('stacktrace')<Cr>
    nnoremap <silent><M-m>4 :call GoToVimspectorWindow('code')<Cr>
    nnoremap <silent><M-m>5 :call GoToVimspectorWindow('terminal')<Cr>
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
    nnoremap mL :Clear<Cr>
    nnoremap mb :Break<Cr>
    " debug
    nnoremap md :Termdebug
    nnoremap mc :TermdebugCommand<Space>
    nnoremap mm :Continue<Cr>
    nnoremap ms :Step<Cr>
    nnoremap mo :Over<Cr>
    nnoremap mu :Finish<Cr>
    nnoremap mr :Run<Space>
    nnoremap ma :Arguments<Space>
    nnoremap me :Evaluate<Space>
    nnoremap <M-d>p :Program<Cr>
    nnoremap <M-d>o :Source<Cr>
    nnoremap <M-d>d :Gdb<Cr>
    nnoremap <M-d>a :Asm<Cr>
endif
