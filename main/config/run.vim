" --------------------------
" set asyncrun_open
" --------------------------
augroup SetRunOpen
    au VimResized,VimEnter * call s:SetRunRows()
augroup END
function! s:SetRunRows()
    let row = float2nr(&lines * 0.2)
    if row < 10 || get(g:, 'asyncrun_open', 10) < 10
        let g:asyncrun_open = 10
    else
        let g:asyncrun_open = row
    endif
endfunction
" --------------------------
" toggle quickfix
" --------------------------
function! s:open_close_qf(open_qf_type) abort
    let open_qf_type = a:open_qf_type
    if open_qf_type < 2
        for i in range(1, winnr('$'))
            let bnum = winbufnr(i)
            if getbufvar(bnum, '&buftype') == 'quickfix'
                cclose
                lclose
                return
            endif
        endfor
    endif
    if open_qf_type > 0
        let t:quickfix_return_to_window = winnr()
        execute "copen " . g:asyncrun_open
        execute t:quickfix_return_to_window . "wincmd w"
    endif
endfunction
command! CloseQuickfix  call s:open_close_qf(0)
command! ToggleQuickfix call s:open_close_qf(1)
command! OpenQuickfix   call s:open_close_qf(2)
" --------------------------
" asyncrun
" --------------------------
if has('nvim') || has('timers') && has('channel') && has('job')
    let g:asyncrun_rootmarks = g:root_patterns
    nnoremap <silent><Tab>q :AsyncStop!<CR>
    nnoremap <silent><Tab>Q :AsyncStop<CR>
    nnoremap <leader>R :AsyncRun
    let g:run_command = "AsyncRun"
    PackAdd 'asyncrun.vim'
else
    let g:run_command = "!"
    nnoremap <leader>R :!
endif
if WINDOWS()
    let g:asyncrun_encs = get(g:, 'asyncrun_encs', 'gbk')
endif
if UNIX() && g:run_command == 'AsyncRun'
    call system("mkdir -p ~/.cache/build")
    let g:gcc_cmd = get(g:, 'gcc_cmd', 'time gcc -Wall -O2 $(VIM_FILEPATH) -o $HOME/.cache/build/$(VIM_FILENOEXT) && time $HOME/.cache/build/$(VIM_FILENOEXT)')
    let g:gpp_cmd = get(g:, 'gpp_cmd', 'time g++ -Wall -O2 $(VIM_FILEPATH) -o $HOME/.cache/build/$(VIM_FILENOEXT) && time $HOME/.cache/build/$(VIM_FILENOEXT)')
    if executable('rustc')
        let g:rustc_cmd = get(g:, 'rustc_cmd', 'time rustc -o $(VIM_FILENOEXT) --out-dir $HOME/.cache/build/$(VIM_FILEPATH) && time $HOME/.cache/build/$(VIM_FILENOEXT)')
    endif
elseif WINDOWS() && g:run_command == 'AsyncRun'
    if executable('gcc')
        let g:gcc_cmd = get(g:, 'gcc_cmd', 'md build 2>NULL & ptime gcc $(VIM_FILEPATH) -o build\$(VIM_FILENOEXT).exe & ptime build\$(VIM_FILENOEXT).exe')
        let g:gpp_cmd = get(g:, 'gpp_cmd', 'md build 2>NULL & ptime g++ $(VIM_FILEPATH) -o build\$(VIM_FILENOEXT).exe & ptime build\$(VIM_FILENOEXT).exe')
    endif
    if executable('rustc')
        let g:rustc_cmd = get(g:, 'rustc_cmd', 'md build 2>NULL & ptime rustc -o build\$(VIM_FILENOEXT).exe $(VIM_FILEPATH) & ptime build\$(VIM_FILENOEXT).exe')
    endif
endif
function! s:RunNow(...)
    w!
    if a:0 > 0
        let type = a:1
    else
        let type = 'quickfix'
    endif
    if type < 0 | let type = 0 | endif
    if &filetype != '' && &filetype != 'markdown' && &filetype != 'startify'
        if g:run_command == "!"
            let params = " "
        elseif g:has_terminal
            if type == 'tab'
                let params = ' -cwd=$(VIM_FILEDIR) -mode=term -pos=tab -focus=1 -reuse'
            elseif type == 'floaterm'
                if has('nvim')
                    let params = ' -cwd=$(VIM_FILEDIR) -mode=term -pos=floaterm -position=topright -width=0.45 -height=0.65 -focus=0'
                else
                    let params = ' -cwd=$(VIM_FILEDIR) -mode=term -pos=floaterm -position=topright -width=0.45 -height=0.65'
                endif
            elseif type == 'external' && WINDOWS()
                let params = ' -cwd=$(VIM_FILEDIR) -mode=term -pos=external -focus=0'
            else
                let params = " -cwd=$(VIM_FILEDIR) -mode=async"
            endif
        else
            if has('patch-7.4.1829') || has('nvim')
                let params = ' -cwd=$(VIM_FILEDIR) -mode=async'
            else
                let params = ' -cwd=$(VIM_FILEDIR) -mode=bang'
            endif
        endif
        if &filetype ==# 'dosbatch'
            exec g:run_command . params. ' ptime %'
        elseif &filetype ==# 'python'
            if get(g:, 'python_exe_path', '') != ''
                if WINDOWS()
                    exec g:run_command . params . ' ptime ' . g:python_exe_path . ' %'
                else
                    exec g:run_command . params . " time " . g:python_exe_path . ' %'
                endif
            else
                if WINDOWS()
                    exec g:run_command . params . ' ptime python %'
                else
                    exec g:run_command . params . ' time python %'
                endif
            endif
        elseif &filetype ==# 'perl' && executable('perl')
            if WINDOWS()
                exec g:run_command . params . ' ptime perl %'
            else
                exec g:run_command . params . ' time perl %'
            endif
        elseif &filetype ==# 'javascript' && executable('node')
            if WINDOWS()
                exec g:run_command . params . ' ptime node %'
            else
                exec g:run_command . params . ' time node %'
            endif
        elseif &filetype ==# 'sh' && executable('bash')
            exec g:run_command . params . ' time bash %'
        elseif &filetype ==# 'go' && executable('go')
            if WINDOWS()
                exec g:run_command . params . ' ptime go run %'
            else
                exec g:run_command . params . ' time  go run %'
            endif
        elseif &filetype == 'c' && get(g:, 'gcc_cmd', '') != ''
            exec g:run_command . params . ' '. g:gcc_cmd
        elseif &filetype == 'cpp' && get(g:, 'gpp_cmd', '') != ''
            exec g:run_command . params . ' '. g:gpp_cmd
        elseif &filetype == 'rust' && get(g:, 'rustc_cmd', '') != ''
            exec g:run_command . params . ' '. g:rustc_cmd
            " if WINDOWS()
            "     exec g:run_command . params . ' ptime rustc %'
            " else
            "     exec g:run_command . params . ' time  rustc %'
            " endif
        else
            call feedkeys(':' . g:run_command)
        endif
        if params =~ "mode=async"
            if type == 'right'
                call feedkeys("\<C-w>H", "n")
                call feedkeys("\<C-w>w", "n")
            elseif type == 'quickfix'
                call feedkeys("\<C-w>w", "n")
                execute 'copen ' . g:asyncrun_open
            endif
        endif
    endif
endfunction
command! RunBottom call <SID>RunNow()
command! RunRight  call <SID>RunNow('right')
nnoremap <M-B> :RunBottom<CR>
nnoremap <M-R> :RunRight<CR>
if g:has_terminal
    command! RunTerm call <SID>RunNow('tab')
    nnoremap <M-T> :RunTerm<CR>
endif
if WINDOWS()
    command! RunExternal call <SID>RunNow('external')
    nnoremap <M-F> :RunExternal<CR>
elseif g:has_terminal > 0
    " intergrated with asynctasks
    function! s:runner_proc(opts)
        let curr_bufnr = floaterm#curr()
        if has_key(a:opts, 'silent') && a:opts.silent == 1
            call floaterm#hide()
        endif
        let cmd = 'cd ' . shellescape(getcwd())
        call floaterm#terminal#send(curr_bufnr, [cmd])
        call floaterm#terminal#send(curr_bufnr, [a:opts.cmd])
        stopinsert
        if &filetype == 'floaterm' && g:floaterm_autoinsert
            startinsert
        endif
    endfunction
    let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
    let g:asyncrun_runner.floaterm = function('s:runner_proc')
    command! RunFloaterm call <SID>RunNow('floaterm')
    nnoremap <M-F> :RunFloaterm<CR>
endif
" ----------------
" asynctasks
" ----------------
if has('nvim') || v:version >= 801
    let g:asynctasks_config_name  = [".git/tasks.ini", ".hg/tasks.ini", ".svn/tasks.ini", ".root/tasks.ini"]
    let g:asynctasks_rtp_config   = "tasks.ini"
    let g:asynctasks_term_reuse   = 1
    let g:asynctasks_term_focus   = 0
    let g:asynctasks_term_listed  = 0
    let g:asynctasks_template = '~/.leovim.conf/asynctasks/tasks_template.ini'
    " packadd
    PackAdd 'asynctasks.vim'
    " open template
    nnoremap <leader>r<Cr> :tabe $LEOVIM_PATH/asynctasks/tasks_example.ini<Cr>
    nnoremap <leader>r<Tab> :call mkdir(expand("~/.config/asynctask"), 'p')<Cr>:tabe $HOME/.config/asynctask/tasks.ini<Cr>
    " asynctask shortcuts
    nnoremap <leader>r<tab> :AsyncTask
    nnoremap <leader>rm :AsyncTaskMacro<Cr>
    nnoremap <leader>re :AsyncTaskEdit<Space>
    " run shortcuts
    nnoremap <leader>rr :AsyncTask project-run<Cr>
    nnoremap <leader>ri :AsyncTask project-init<Cr>
    nnoremap <leader>rb :AsyncTask project-build<Cr>
    nnoremap <leader>rd :AsyncTask project-debug<Cr>
    nnoremap <leader>rc :AsyncTask project-compile<Cr>
    nnoremap <leader>rt :AsyncTask project-test<Cr>
    function! AsyncTaskProfileLoop() abort
        if get(g:, 'asynctasks_profile', '') == ''
            let g:asynctasks_profile = 'debug'
        elseif g:asynctasks_profile == 'debug'
            let g:asynctasks_profile = 'build'
        elseif g:asynctasks_profile == 'build'
            let g:asynctasks_profile = 'release'
        elseif g:asynctasks_profile == 'release'
            let g:asynctasks_profile = 'debug'
        endif
        echom "asynctasks_profile is " . g:asynctasks_profile
    endfunction
    command! AsyncTaskProfileLoop call AsyncTaskProfileLoop()
    nnoremap <leader>rl :<C-u>AsyncTaskProfileLoop<CR>
    nnoremap <leader>rp :<C-u>AsyncTaskProfile<CR>
    if Installed('telescope-asynctasks.nvim')
        nnoremap <silent><M-r> :lua require('telescope').extensions.asynctasks.all()<Cr>
    elseif get(g:, 'fuzzy_finder', '') =~ 'leaderf'
        function! s:lf_task_source(...)
            let rows = asynctasks#source(&columns * 48 / 100)
            let source = []
            for row in rows
                let name = row[0]
                let source += [name . '  ' . row[1] . '  : ' . row[2]]
            endfor
            return source
        endfunc
        function! s:lf_task_accept(line, arg)
            let pos = stridx(a:line, '<')
            if pos < 0
                return
            endif
            let name = strpart(a:line, 0, pos)
            let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
            if name != ''
                exec "AsyncTask " . name
            endif
        endfunc
        function! s:lf_task_digest(line, mode)
            let pos = stridx(a:line, '<')
            if pos < 0
                return [a:line, 0]
            endif
            let name = strpart(a:line, 0, pos)
            return [name, 0]
        endfunc
        function! s:lf_win_init(...)
            setlocal nonumber
            setlocal nowrap
        endfunc
        let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
        let g:Lf_Extensions.tasks = {
                    \ 'source': string(function('s:lf_task_source'))[10:-3],
                    \ 'accept': string(function('s:lf_task_accept'))[10:-3],
                    \ 'get_digest': string(function('s:lf_task_digest'))[10:-3],
                    \ 'highlights_def': {
                        \     'Lf_hl_funcScope': '^\S\+',
                        \     'Lf_hl_funcDirname': '^\S\+\s*\zs<.*>\ze\s*:',
                        \ },
                        \ }
        nnoremap <silent><M-r> :Leaderf tasks<Cr>
    elseif get(g:, 'fuzzy_finder', '') =~ 'fzf'
        function! s:fzf_sink(what)
            let p1 = stridx(a:what, '<')
            if p1 >= 0
                let name = strpart(a:what, 0, p1)
                let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
                if name != ''
                    exec "AsyncTask ". fnameescape(name)
                endif
            endif
        endfunction
        function! s:fzf_task()
            let rows = asynctasks#source(&columns * 48 / 100)
            let source = []
            for row in rows
                let name = row[0]
                let source += [name . '  ' . row[1] . '  : ' . row[2]]
            endfor
            let opts = { 'source': source, 'sink': function('s:fzf_sink'),
                        \ 'options': '+m --nth 1 --inline-info --tac' }
            if exists('g:fzf_layout')
                for key in keys(g:fzf_layout)
                    let opts[key] = deepcopy(g:fzf_layout[key])
                endfor
            endif
            call fzf#run(opts)
        endfunction
        command! -nargs=0 FZFAsyncTask call s:fzf_task()
        nnoremap <silent><M-r> :FZFAsyncTask<Cr>
    endif
endif
