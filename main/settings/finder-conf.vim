" --------------------------
" fuzzy_finder config
" --------------------------
if Installed('leaderf')
    if Installed('coc.nvim')
        let g:fuzzy_finder = 'leaderf-coc-fzf'
    elseif InstalledTelescope()
        let g:fuzzy_finder = 'leaderf-telescope'
    else
        let g:fuzzy_finder = 'leaderf-fzf'
    endif
    nnoremap <silent><C-p> :Leaderf self<Cr>
    nnoremap <leader>F :Leaderf
elseif Installed('coc.nvim')
    let g:fuzzy_finder = 'coc-fzf'
    nnoremap <silent><C-p> :CocFzfList<Cr>
    nnoremap <leader>F :CocFzfList<Space>
elseif InstalledTelescope()
    let g:fuzzy_finder = 'telescope'
    nnoremap <silent><C-p> :Telescope<Cr>
    nnoremap <leader>F :Telescope<Space>
elseif InstalledFzf()
    let g:fuzzy_finder = 'fzf'
    nnoremap <silent><C-p> :FZFFiles .<Cr>
else
    let g:fuzzy_finder = ''
endif
if InstalledTelescope() && InstalledLsp()
    luafile $LUA_PATH/telescope-config.lua
    lua << EOF
    _G.project_files = function()
      local search_opts = {}
      local ok = pcall(require"telescope.builtin".git_files, search_opts)
      if not ok then require"telescope.builtin".find_files(search_opts) end
    end
EOF
    nnoremap <leader>fg :lua project_files()<Cr>
    nnoremap m<tab> <cmd>Telescope keymaps<Cr>
    nnoremap <M-l>. :Telescope resume<Cr>
    if Installed('leaderf')
        nnoremap <silent>q; :Telescope<Cr>
    endif
elseif InstalledFzf()
    " --------------------------
    "  fzf basic settings
    " --------------------------
    nnoremap q, :FZF<Tab>
    if !Installed('coc.nvim')
        nnoremap q; :Fzf<Tab>
    endif
    if WINDOWS()
        let $FZF_DEFAULT_OPTS = '--layout=reverse-list'
    else
        let $FZF_DEFAULT_OPTS = '--layout=reverse-list --preview-window=left --border=sharp'
    endif
    if has('nvim') || has('patch-8.2.191')
        let g:fzf_layout = {'up':'~90%',
            \ 'window': {'width': 0.8, 'height': 0.8, 'yoffset': 0.5, 'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp'}
            \ }
        if WINDOWS()
            let g:fzf_preview_window = ['right:40%:hidden', 'ctrl-/']
        else
            let g:fzf_preview_window = ['right:40%', 'ctrl-/']
        endif
    else
        let g:fzf_layout = {'down': '~30%'}
    endif
    au FileType fzf tnoremap <buffer> <C-j> <Down>
    au FileType fzf tnoremap <buffer> <C-k> <Up>
    au FileType fzf tnoremap <buffer> <C-n> <Nop>
    au FileType fzf tnoremap <buffer> <C-p> <Nop>
    " preview position
    let g:fzf_command_prefix = 'Fzf'
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1
    " [[B]Commits] Customize the options used by 'git log':
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
    " [Commands] --expect expression for directly executing the command
    let g:fzf_commands_expect = 'alt-enter'
    function! s:build_quickfix_list(lines)
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen g:asyncrun_open
        cc
    endfunction
    let g:fzf_action = {
                \ 'ctrl-e': function('s:build_quickfix_list'),
                \ 'enter':  'edit',
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit'
                \ }
    " --------------------------
    "  fzf maps
    " --------------------------
    nmap ,m <plug>(fzf-maps-n)
    xmap ,m <plug>(fzf-maps-x)
    omap ,m <plug>(fzf-maps-o)
    " --------------------------
    "  fzf files
    " --------------------------
    if UNIX() | nnoremap <leader>fl :FZFLocate<Space> | endif
    command! -bang -nargs=? -complete=dir FZFGFiles
          \ call fzf#vim#gitfiles(<q-args>,
          \     fzf_preview#p(<bang>0),
          \     <bang>0)
    function! s:files_search()
        if get(g:, 'coc_git_status', '') != '' || get(b:, 'git_root_path', '') != ''
            FZFGFiles
        else
            lcd %:p:h
            if Installed('leaderf')
                LeaderfFile
            else
                FZF
            endif
        endif
    endfunction
    command! FilesSearch call s:files_search()
    nnoremap <silent> <leader>fg :FilesSearch<Cr>
endif
" --------------------------
" using leaderf cache dir
" --------------------------
let g:Lf_CacheDirectory = expand("~/.leovim.d")
if get(g:, 'fuzzy_finder', '') =~ 'leaderf'
    " config
    au FileType leaderf set nonu
    let g:Lf_RootMarkers   = g:root_patterns
    let g:Lf_DefaultMode   = 'Fuzzy'
    let g:Lf_ReverseOrder  = 0
    let g:Lf_NoChdir       = 1
    let g:Lf_ShowDevIcons  = 0
    let g:Lf_PythonVersion = float2nr(g:python_version)
    if g:has_popup_float
        let g:Lf_PreviewInPopup = 1
        let g:Lf_WindowPosition = 'popup'
        let g:Lf_PopupWidth     = 0.85
        let g:Lf_PopupHeight    = 0.7
    else
        let g:Lf_PreviewInPopup = 0
    endif
    let g:Lf_WorkingDirectoryMode = 'f'
    let g:Lf_WildIgnore = {
                \ 'dir': g:root_patterns,
                \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*tags']
                \ }
    let g:Lf_NormalMap = {
                \ "File":        [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
                \ "Filer":       [["<ESC>", ':exec g:Lf_py "filerExplManager.quit()"<CR>']],
                \ "Buffer":      [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
                \ "Mru":         [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
                \ "Tag":         [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
                \ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
                \ "Colorscheme": [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
                \ }
    let g:Lf_CommandMap = {'<C-]>': ['<C-V>'], '<C-V>': ['<C-]>'], '<F5>': ['<F5>', '<C-l>'], '<Up>': ['<Up>', '<C-u>'], '<Down>': ['<Down>', '<C-d>']}
    " main selector
    nnoremap <leader>b :LeaderfBufferAll<Cr>
    nnoremap <leader>B :LeaderfTabBufferAll<Cr>
    nnoremap <leader>m :LeaderfMru<Cr>
    nnoremap <leader>M :LeaderfMruCwd<Cr>
    nnoremap q/ :Leaderf searchHistory<Cr>
    nnoremap q: :Leaderf cmdHistory<Cr>
    nnoremap ,; :Leaderf --next<Cr>
    nnoremap ,, :Leaderf --previous<Cr>
    nnoremap ,. :Leaderf --recall<Cr>
    " mru cwd
    " replace origin command
    nnoremap <M-k>s :Leaderf colorscheme<Cr>
    nnoremap <M-k>t :Leaderf filetype<Cr>
    nnoremap <M-k>c :Leaderf command<Cr>
    " help tags
    nnoremap <M-k><M-k> :LeaderfHelp<Cr>
    " line
    nnoremap <M-l><M-l> :Leaderf line --no-sort --regexMode<Cr>
    nnoremap <M-l>a     :Leaderf line --all --no-sort<Cr>
    nnoremap <M-l>n     :Leaderf line --no-sort<Cr>
    " jumps
    nnoremap <M-h><M-h> :Leaderf jumps<cr>
    " leader-filer
    let g:Lf_FilerShowPromptPath = 1
    " normal mode
    let g:Lf_FilerUseDefaultNormalMap = 0
    let g:Lf_FilerNormalMap = {
                \ '<C-h>': 'open_parent',
                \ '<C-l>': 'open_current',
                \ '~':     'goto_root_marker_dir',
                \ 'H':     'toggle_hidden_files',
                \ 'j':     'down',
                \ 'k':     'up',
                \ '<F1>':  'toggle_help',
                \ '<F2>':  'rename',
                \ '<F3>':  'clear_selections',
                \ '<Tab>': 'switch_insert_mode',
                \ 'i':     'switch_insert_mode',
                \ 'p':     'preview',
                \ 'q':     'quit',
                \ 'o':     'accept',
                \ '<CR>':  'accept',
                \ '<C-x>': 'accept_horizontal',
                \ '<C-v>': 'accept_vertical',
                \ '<C-t>': 'accept_tab',
                \ '<C-k>': 'page_up_in_preview',
                \ '<C-j>': 'page_down_in_preview',
                \ '<Esc>': 'close_preview_popup',
                \ 's':     'add_selections',
                \ '<C-a>': 'select_all',
                \ 'K':     'mkdir',
                \ 'C':     'copy',
                \ 'P':     'paste',
                \ 'O':     'create_file',
                \ '@':     'change_directory',
                \}
    " insert mode
    let g:Lf_FilerUseDefaultInsertMap = 0
    let g:Lf_FilerInsertMap = {
                \ '<C-h>':              'open_parent_or_backspace',
                \ '<C-l>':              'open_current',
                \ '<C-y>':              'toggle_hidden_files',
                \ '<C-g>':              'goto_root_marker_dir',
                \ '<Esc>':              'quit',
                \ '<C-c>':              'quit',
                \ '<CR>':               'accept',
                \ '<C-x>':              'accept_horizontal',
                \ '<C-v>':              'accept_vertical',
                \ '<C-t>':              'accept_tab',
                \ '<C-r>':              'toggle_regex',
                \ '<BS>':               'backspace',
                \ '<C-u>':              'clear_line',
                \ '<C-w>':              'delete_left_word',
                \ '<C-d>':              'delete',
                \ '<C-o>':              'paste',
                \ '<C-a>':              'home',
                \ '<C-e>':              'end',
                \ '<C-b>':              'left',
                \ '<C-f>':              'right',
                \ '<C-j>':              'down',
                \ '<C-k>':              'up',
                \ '<C-p>':              'prev_history',
                \ '<C-n>':              'next_history',
                \ '<C-q>':              'preview',
                \ '<Tab>':              'switch_normal_mode',
                \ '<C-Up>':             'page_up_in_preview',
                \ '<C-Down>':           'page_down_in_preview',
                \ '<ScroollWhellUp>':   'up3',
                \ '<ScroollWhellDown>': 'down3',
                \}
    " Customize normal mode mapping using g:Lf_NormalMap
    let g:Lf_NormalMap.Filer = [['B', ':LeaderfBookmark<CR>']]
    " open leader quickfix/loclist
    nnoremap Z<S-Cr> :CloseQuickfix<Cr>:Leaderf quickfix<Cr>
    nnoremap Z<Cr>   :CloseQuickfix<Cr>:Leaderf loclist<Cr>
elseif InstalledTelescope()
    nnoremap <M-h><M-h> <cmd>Telescope jumplist<cr>
    nnoremap <leader>b <cmd>Telescope buffers<Cr>
    nnoremap <leader>m <cmd>Telescope oldfiles<Cr>
    nnoremap q/ <cmd>Telescope search_history<Cr>
    nnoremap q: <cmd>Telescope command_history<Cr>
    " replace origin command
    nnoremap <M-k>s <cmd>Telescope colorscheme<Cr>
    nnoremap <M-k>t <cmd>Telescope filetypes<Cr>
    nnoremap <M-k>c <cmd>Telescope commands<cr>
    nnoremap Z<S-Cr> :CloseQuickfix<Cr>:Telescope quickfix<CR>
    nnoremap Z<Cr>   :CloseQuickfix<Cr>:Telescope loclist<CR>
    nnoremap <M-k><M-k> <cmd>Telescope help_tags<CR>
elseif InstalledFzf()
    let g:fuzzy_finder = get(g:, 'fuzzy_finder', 'fzf')
    nnoremap <leader>b :FzfBuffers<CR>
    nnoremap <leader>m :FZFMru<CR>
    nnoremap q/ :FZFHistory/<CR>
    nnoremap q: :FZFHistory:<CR>
    " replace origin command
    nnoremap <M-k>s :FzfColors<CR>
    nnoremap <M-k>t :FzfFiletypes<CR>
    nnoremap <M-k>c :FzfCommands<CR>
    nnoremap Z<S-Cr> :CloseQuickfix<Cr>:FZFQuickFix<CR>
    nnoremap Z<Cr>   :CloseQuickfix<Cr>:FZFLocList<CR>
    nnoremap <M-l><M-l> :FZFBLines<CR>
    " helptags
    if executable('perl')
        nnoremap <M-k><M-k> :FzfHelptags<CR>
    endif
    " FZF jumps
    try
        " if fail l:jl, jumps cannot be used
        let l:jl = execute('jumps')
        unlet l:jl
        " functions
        function! s:jumpListFormat(val) abort
            let l:file_name = bufname('%')
            let l:file_name = empty(l:file_name) ? 'Unknown file name' : l:file_name
            let l:curpos = getcurpos()
            let l:l = matchlist(a:val, '\(>\?\)\s*\(\d*\)\s*\(\d*\)\s*\(\d*\) \?\(.*\)')
            let [l:mark, l:jump, l:line, l:col, l:content] = l:l[1:5]
            if empty(trim(l:mark)) | let l:mark = '-' | endif
            if filereadable(expand(fnameescape(l:content)))
                let l:file_name = expand(l:content)
                let l:bn = bufnr(l:file_name)
                if l:bn > -1 && buflisted(l:bn) > 0
                    let l:content = getbufline(l:bn, l:line)
                    let l:content = empty(l:content) ? "" : l:content[0]
                else
                    let l:content = system("sed -n " . l:line . "p " . l:file_name)
                endif
            elseif empty(trim(l:content))
                if empty(trim(l:line))
                    let [l:line, l:col] = l:curpos[1:2]
                endif
                let l:content = getline(l:line, l:line)[0]
            endif
            return l:mark . " " . l:file_name . ":" . l:line . ":" . l:col . " " . l:content
        endfunction
        function! s:jumpList() abort
            let l:jl = execute('jumps')
            return map(reverse(split(l:jl, '\n')[1:]), 's:jumpListFormat(v:val)')
        endfunction
        function! s:jumpHandler(jp)
            let l:l = matchlist(a:jp, '\(.\)\s\(.*\):\(\d\+\):\(\d\+\)\(.*\)')
            let [l:file_name, l:line, l:col, l:content] = l:l[2:5]
            if empty(l:file_name) || empty(l:line) | return | endif
            " 判断文件是否已经存在 buffer 中
            let l:bn = bufnr(l:file_name)
            " 未打开
            if l:bn == -1 | if filereadable(l:file_name) | execute 'e ' . 'l:file_name' | endif
            else | execute 'buffer ' . l:bn | endif
            call cursor(str2nr(l:line), str2nr(l:col))
            normal! zvzz
        endfunction
        function! s:FZFJumps() abort
            if WINDOWS()
                call fzf#run(fzf#wrap({
                        \ 'source': s:jumpList(),
                        \ 'sink': function('s:jumpHandler'),
                        \ 'options': [
                            \ '--prompt=Jumps>'
                        \ ],
                        \ }))
            else
                call fzf#run(fzf#wrap({
                        \ 'source': s:jumpList(),
                        \ 'sink': function('s:jumpHandler'),
                        \ 'options': [
                            \ '--prompt=Jumps>',
                            \ '--preview', $LEOVIM_PATH . '/bin/preview.sh {2}',
                            \ '--preview-window=up:35%'
                        \ ],
                        \ }))
            endif
        endfunction
        command! -bang -nargs=* FZFJumps call s:FZFJumps()
        nnoremap <M-h><M-h> :FZFJumps<cr>
    catch
        " pass
    endtry
endif
if Installed('leaderf-tabs')
    nnoremap <leader>t :Leaderf tabs<Cr>
elseif Installed('fzf-tabs')
    nnoremap <leader>t :FZFTabs<CR>
endif
" --------------------------
" notify
" --------------------------
if Installed("nvim-notify")
    function! s:notify_messages() abort
        let g:notify_messages=split(execute('messages'), "\n")
        if empty(g:notify_messages)
            echo "No messages"
        endif
        lua require('notify')(vim.g.notify_messages, 'info', {title = 'messages'})
        unlet g:notify_messages
    endfunction
    nnoremap <silent>,m :call <SID>notify_messages()<Cr>
    if !InstalledTelescope()
        nnoremap <silent>,N <cmd>lua require("notify").history()<Cr>
    endif
endif
" --------------------------
" quickui
" --------------------------
if Installed('vim-quickui')
    let g:quickui_border_style = 2
    if !Installed('nvim-notify')
        nnoremap <silent>,m :call quickui#tools#display_messages()<Cr>
    endif
    nnoremap <F13> :call quickui#preview#scroll(1)<Cr>
    nnoremap <F14> :call quickui#preview#scroll(-1)<Cr>
    if Installed('coc.nvim')
        nmap <silent><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : quickui#preview#visible() > 0 ? "\<F13>" : "\%"
        nmap <silent><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : quickui#preview#visible() > 0 ? "\<F14>" : "\g%"
    else
        nmap <silent><expr> <C-j> quickui#preview#visible() > 0 ? "\<F13>" : "\%"
        nmap <silent><expr> <C-k> quickui#preview#visible() > 0 ? "\<F14>" : "\g%"
    endif
    " preview in popup
    function! s:PreviewFileW(filename) abort
        let filename = a:filename
        let fopts = {'cursor':-1, 'number':1, 'persist':0, 'w':80, 'h':64}
        call quickui#preview#open(filename, fopts)
    endfunction
    command! -nargs=1 -complete=file PreviewFileW call s:PreviewFileW(<f-args>)
    nnoremap ,<Tab> :PreviewFileW<Space>
endif
" --------------------------
" changes
" --------------------------
if Installed('leaderf-changes')
    nnoremap <silent><M-y> :Leaderf changes<Cr>
elseif Installed('coc.nvim')
    nnoremap <silent><M-y> :CocFzfList changes<Cr>
endif
" --------------------
" browser files all
" --------------------
if Installed('leaderf')
    let g:Lf_ShortcutF = '<leader>ff'
    nnoremap <silent><leader>ff :lcd %:p:h \| LeaderfFile<Cr>
elseif InstalledFzf()
    nnoremap <silent><leader>ff :lcd %:p:h \| FZF<Cr>
endif
" map config and open file using system browser when has gui
if g:gui_running
    nnoremap <M-i> :tabnew
    nnoremap <M-I> :tabclose<Cr>
    " TabSwitch
    nnoremap <M-n> gt
    nnoremap <M-p> gT
    nnoremap <silent><M-N> :tabm +1<Cr>
    nnoremap <silent><M-P> :tabm -1<Cr>
    nnoremap <M-M> :tabm<Space>
endif
if executable('ranger') && UNIX() && get(g:, 'floaterm_floating', 0)
    command! Ranger FloatermNew --wintype=float --position=center --height=0.9 --width=0.9 --name=ranger --autoclose=2 ranger --cmd="cd ./"
    nnoremap <silent><leader>N :Ranger<Cr>
elseif !has('nvim') && WINDOWS() && g:gui_running
    let g:browsefilter = ''
    function! s:Filter_Push(desc, wildcard)
        let g:browsefilter .= a:desc . " (" . a:wildcard . ")\t" . a:wildcard . "\n"
    endfunc
    function! OpenBrowser()
        let l:path = expand("%:p:h")
        if l:path == '' | let l:path = getcwd() | endif
        if exists('g:browsefilter') && exists('b:browsefilter')
            if g:browsefilter != ''
                let b:browsefilter = g:browsefilter
            endif
        endif
        exec 'browse tabnew '.fnameescape(l:path)
    endfunc
    call s:Filter_Push("All Files", "*")
    call s:Filter_Push("Python", "*.py;*.pyw")
    call s:Filter_Push("C/C++/Object-C", "*.c;*.cpp;*.cc;*.h;*.hh;*.hpp;*.m;*.mm")
    call s:Filter_Push("Rust", "*.rs")
    call s:Filter_Push("Java", "*.java")
    call s:Filter_Push("Text", "*.txt")
    call s:Filter_Push("R", "*.r;*.rmd")
    call s:Filter_Push("Text", "*.txt")
    call s:Filter_Push("Log", "*.log")
    call s:Filter_Push("LaTeX", "*.tex")
    call s:Filter_Push("JavaScript", "*.js;*.vue")
    call s:Filter_Push("TypeScript", "*.ts")
    call s:Filter_Push("Php", "*.php")
    call s:Filter_Push("Vim Script", "*.vim")
    nnoremap <silent><leader>N :call OpenBrowser()<Cr>
endif
if Installed('neo-tree.nvim')
    nnoremap <silent><leader>n :NeoTreeFloatToggle<Cr>
elseif exists(':CocFile')
    nnoremap <silent><leader>n :CocFile<Cr>
elseif InstalledFzf()
    nnoremap <silent><leader>n :FZFFiles .<Cr>
endif
" --------------------------
" floaterm windows
" --------------------------
if Installed('LeaderF-floaterm')
    nnoremap <leader>w :Leaderf floaterm<Cr>
elseif Installed('fzf-floaterm')
    nnoremap <leader>w :Floaterms<Cr>
endif
