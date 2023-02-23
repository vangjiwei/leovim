" --------------------------
" fuzzy_finder config
" --------------------------
let g:Lf_CacheDirectory = expand("~")
if Installed('leaderf')
    if Installed('coc.nvim')
        let g:fuzzy_finder = 'leaderf-coc-fzf'
    elseif InstalledTelescope()
        let g:fuzzy_finder = 'leaderf-telescope'
    elseif InstalledFZF()
        let g:fuzzy_finder = 'leaderf-fzf'
    else
        let g:fuzzy_finder = 'leaderf'
    endif
    nnoremap <leader>F :Leaderf
    nnoremap <silent><C-p> :Leaderf self<Cr>
    nnoremap <silent><M-h>h :LeaderfHelp<Cr>
    au FileType vim,help nnoremap <C-h> :LeaderfHelpCword<Cr>
    if InstalledTelescope()
        nnoremap <leader>P :Telescope<Cr>
    elseif InstalledFZF()
        if Installed('coc.nvim')
            nnoremap <leader>P :CocFzfList<Cr>
        else
            nnoremap <leader>P :FZF
        endif
    endif
elseif Installed('coc.nvim')
    let g:fuzzy_finder = 'coc-fzf'
    nnoremap <silent><C-p> :CocFzfList<Cr>
elseif InstalledTelescope()
    let g:fuzzy_finder = 'telescope'
    nnoremap <silent><C-p> :Telescope<Cr>
    nnoremap <silent><M-h>h :Telescope help_tags<Cr>
elseif InstalledFZF()
    let g:fuzzy_finder = 'fzf'
    nnoremap <silent><C-p> :FZF
else
    let g:fuzzy_finder = ''
endif
" --------------------------
" fzf
" --------------------------
if InstalledFZF()
    " --------------------------
    " fzf basic settings
    " --------------------------
    let $FZF_DEFAULT_OPTS = '--layout=reverse-list --info=inline'
    if has('nvim') || has('patch-8.2.191')
        let g:fzf_layout = {'up':'~80%',
            \ 'window': {'width': 0.9, 'height': 0.8, 'border': 'sharp'}
            \ }
        let g:fzf_preview_window = ['right,45%,<80(up,30%)', 'ctrl-/']
    else
        let g:fzf_layout = {'down': '~30%'}
        let g:fzf_preview_window = ['right,45%', 'ctrl-/']
    endif
    au FileType fzf tnoremap <buffer> <C-j> <Down>
    au FileType fzf tnoremap <buffer> <C-k> <Up>
    au FileType fzf tnoremap <buffer> <C-n> <Nop>
    au FileType fzf tnoremap <buffer> <C-p> <Nop>
    " preview position
    let g:fzf_command_prefix = 'FZF'
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1
    " [[B]Commits] Customize the options used by 'git log':
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
    " [Commands] --expect expression for directly executing the command
    let g:fzf_commands_expect = 'alt-enter'
    function! s:build_quickfix_list(lines)
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        " call execute("copen " . g:asyncrun_open)
        " cc
    endfunction
    let g:fzf_action = {
                \ 'enter':  'edit',
                \ 'ctrl-e': function('s:build_quickfix_list'),
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-x': 'split',
                \ 'ctrl-]': 'vsplit'
                \ }
    " --------------------------
    " fzf maps
    " --------------------------
    nmap m<tab> <plug>(fzf-maps-n)
    xmap m<tab> <plug>(fzf-maps-x)
    omap m<tab> <plug>(fzf-maps-o)
    " --------------------------
    " fzf grep
    " --------------------------
    command! -bang -nargs=* FZFGGrep
                \ call fzf#vim#grep(
                \   'git grep -I --line-number --color=always -- ' . shellescape(empty(<q-args>) ? '^' : <q-args>),
                \   0,
                \   fzf#vim#with_preview(),
                \   <bang>0)
                " \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}),
    command! -bang -nargs=* FZFRg
                \ call fzf#vim#grep(
                \   'rg --column --line-number --no-heading --color=always --smart-case -- ' . shellescape(empty(<q-args>) ? '^' : <q-args>),
                \   1,
                \   fzf#vim#with_preview(),
                \   <bang>0)
    " --------------------------
    " fzf grep
    " --------------------------
    if get(g:, "terminal_plus", "") =~ 'floaterm'
        command! FloatermRg FloatermNew --width=0.8 --height=0.8 rg
        nnoremap <silent><Tab>/ :FloatermRg<Cr>
    endif
    " -------------------------
    "  fzf files
    " --------------------------
    if UNIX() | nnoremap <leader>fl :FZFLocate<Space> | endif
    function! s:files_search()
        if get(g:, 'coc_git_status', '') != '' || get(b:, 'git_root_path', '') != ''
            FZFGitFiles
        else
            lcd %:p:h
            if Installed('leaderf')
                LeaderfFile
            else
                FZF
            endif
        endif
    endfunction
    command! ProjectFiles call s:files_search()
    nnoremap <silent> <leader>fp :ProjectFiles<Cr>
elseif InstalledTelescope()
    luafile $LUA_PATH/telescope.lua
    nnoremap <leader>fp :lua project_files()<Cr>
    nnoremap m<tab> <cmd>Telescope keymaps<Cr>
    nnoremap <M-h>q <cmd>Telescope quickfixhistory<Cr>
    nnoremap <M-h>. <cmd>Telescope resume<Cr>
endif
" --------------------------
" using leaderf cache dir
" --------------------------
if get(g:, 'fuzzy_finder', '') =~ 'leaderf'
    " config
    au FileType leaderf set nonu
    let g:Lf_RootMarkers   = g:root_patterns
    let g:Lf_DefaultMode   = 'Fuzzy'
    let g:Lf_ReverseOrder  = 0
    let g:Lf_NoChdir       = 1
    if Installed('nvim-web-devicons') || Installed('vim-devicons')
        let g:Lf_ShowDevIcons  = 1
    else
        let g:Lf_ShowDevIcons  = 0
    endif
    let g:Lf_PythonVersion = float2nr(g:python_version)
    if g:has_popup_floating
        let g:Lf_WindowPosition = 'popup'
        let g:Lf_PreviewInPopup = 1
        let g:Lf_PopupHeight    = 0.75
        let g:Lf_PopupWidth     = 0.75
        let g:Lf_PopupPosition  = [0, 0]
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
    let g:Lf_CommandMap = {'<C-p>': ['<C-g>'], '<F5>': ['<F5>', '<C-l>'], '<C-l>': ['<C-e>'], '<Up>': ['<Up>', '<C-p>'], '<Down>': ['<Down>', '<C-n>']}
    " history
    nnoremap <M-h>/ :Leaderf searchHistory<Cr>
    nnoremap <M-h>c :Leaderf cmdHistory<Cr>
    " main selector
    nnoremap <leader>b :LeaderfBuffer<Cr>
    nnoremap <leader>B :LeaderfTabBuffer<Cr>
    nnoremap <leader>m :LeaderfMru<Cr>
    nnoremap <leader>M :LeaderfMruCwd<Cr>
    nnoremap <leader>; :Leaderf --next<Cr>
    nnoremap <leader>, :Leaderf --previous<Cr>
    nnoremap <leader>. :Leaderf --recall<Cr>
    " mru cwd
    " replace origin command
    nnoremap <M-k>s :Leaderf colorscheme<Cr>
    nnoremap <M-k>t :Leaderf filetype<Cr>
    nnoremap <M-k><M-k> :Leaderf command<Cr>
    " jumps
    nnoremap <M-j><M-j> :Leaderf jumps<cr>
    " line
    nnoremap <M-l><M-l> :Leaderf line --all --no-sort --regexMode<Cr>
    nnoremap <M-l>a :Leaderf line --all --no-sort<Cr>
    nnoremap <M-l>l :Leaderf line --no-sort<Cr>
    " leader-filer
    let g:Lf_FilerShowPromptPath = 1
    " normal mode
    let g:Lf_FilerUseDefaultNormalMap = 0
    let g:Lf_FilerNormalMap = {
                \ '<C-o>': 'open_parent',
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
                \ '<C-]>': 'accept_vertical',
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
                \ '<C-h>':    'open_parent_or_backspace',
                \ '<C-o>':    'open_current',
                \ '<C-l>':    'toggle_hidden_files',
                \ '<C-g>':    'goto_root_marker_dir',
                \ '<Esc>':    'quit',
                \ '<C-c>':    'quit',
                \ '<CR>':     'accept',
                \ '<C-x>':    'accept_horizontal',
                \ '<C-]>':    'accept_vertical',
                \ '<C-t>':    'accept_tab',
                \ '<C-r>':    'toggle_regex',
                \ '<BS>':     'backspace',
                \ '<C-u>':    'clear_line',
                \ '<C-w>':    'delete_left_word',
                \ '<C-d>':    'delete',
                \ '<C-v>':    'paste',
                \ '<C-a>':    'home',
                \ '<C-e>':    'end',
                \ '<C-b>':    'left',
                \ '<C-f>':    'right',
                \ '<C-j>':    'down',
                \ '<C-k>':    'up',
                \ '<C-p>':    'prev_history',
                \ '<C-n>':    'next_history',
                \ '<C-q>':    'preview',
                \ '<Tab>':    'switch_normal_mode',
                \ '<C-Up>':   'page_up_in_preview',
                \ '<C-Down>': 'page_down_in_preview',
                \}
    " Customize normal mode mapping using g:Lf_NormalMap
    let g:Lf_NormalMap.Filer = [['B', ':LeaderfBookmark<CR>']]
    " open leader quickfix/loclist
    nnoremap Z<S-Cr> :CloseQuickfix<Cr>:Leaderf quickfix<Cr>
    nnoremap Z<Cr>   :CloseQuickfix<Cr>:Leaderf loclist<Cr>
elseif InstalledTelescope()
    nnoremap <M-h>/ <cmd>Telescope search_history<Cr>
    nnoremap <M-h>c <cmd>Telescope command_history<Cr>
    nnoremap <leader>b <cmd>Telescope buffers<Cr>
    nnoremap <leader>m <cmd>Telescope oldfiles<Cr>
    nnoremap <M-j><M-j> <cmd>Telescope jumplist<cr>
    nnoremap <M-k><M-k> <cmd>Telescope commands<cr>
    nnoremap <M-l><M-l> <cmd>Telescope current_buffer_fuzzy_find<cr>
    " replace origin command
    nnoremap <M-k>s <cmd>Telescope colorscheme<Cr>
    nnoremap <M-k>t <cmd>Telescope filetypes<Cr>
    nnoremap Z<S-Cr> :CloseQuickfix<Cr>:Telescope quickfix<CR>
    nnoremap Z<Cr>   :CloseQuickfix<Cr>:Telescope loclist<CR>
elseif InstalledFZF()
    let g:fuzzy_finder = get(g:, 'fuzzy_finder', 'fzf')
    nnoremap <M-h>/ :FZFHistory/<CR>
    nnoremap <M-h>c :FZFHistory:<CR>
    nnoremap <leader>b :FZFBuffers<CR>
    nnoremap <leader>m :FZFMru<CR>
    " replace origin command
    nnoremap <M-k>s :FZFColors<CR>
    nnoremap <M-k>t :FZFFiletypes<CR>
    " FZF jumps
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
        let l:jl = Execute('jumps')
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
    nnoremap <M-j><M-j> :FZFJumps<cr>
    nnoremap <M-l><M-l> :FZFBLines<CR>
    nnoremap <M-k><M-k> :FZFCommands<CR>
endif
" --------------------------
" notify
" --------------------------
if Installed("nvim-notify")
    function! Notify_messages() abort
        let g:notify_messages=split(execute('messages'), "\n")
        if empty(g:notify_messages)
            echo "No messages"
            return
        endif
        lua require('notify')(vim.g.notify_messages, 'info', {title = 'messages'})
        unlet g:notify_messages
    endfunction
    if !InstalledTelescope()
        nnoremap <silent><M-h>n :lua require("notify").history()<Cr>
    endif
    nnoremap <silent><M-h>M :call Notify_messages()<Cr>
endif
" --------------------------
" quickui
" --------------------------
if Installed('vim-quickui')
    let g:quickui_border_style = 2
    nnoremap <silent><M-h>m :call quickui#tools#display_messages()<Cr>
    function! s:PreviewFileO(filename) abort
        let filename = a:filename
        let fopts = {'cursor':-1, 'number':1, 'persist':0, 'w':80, 'h':64}
        call quickui#preview#open(filename, fopts)
    endfunction
    command! -nargs=1 -complete=file PreviewFileO call s:PreviewFileO(<f-args>)
    nnoremap <Tab>O :PreviewFileO
    nnoremap <F13> :call quickui#preview#scroll(1)<Cr>
    nnoremap <F14> :call quickui#preview#scroll(-1)<Cr>
    if Installed('coc.nvim')
        nmap <silent><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : quickui#preview#visible() > 0 ? "\<F13>" : "\%"
        nmap <silent><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : quickui#preview#visible() > 0 ? "\<F14>" : "\g%"
    " TODO : cmp scroll if available
    else
        nmap <silent><expr> <C-j> quickui#preview#visible() > 0 ? "\<F13>" : "\%"
        nmap <silent><expr> <C-k> quickui#preview#visible() > 0 ? "\<F14>" : "\g%"
    endif
    au FileType python nnoremap <C-h> call quickui#tools#python_help("")
endif
" --------------------------
" changes
" --------------------------
if Installed('leaderf-changes')
    nnoremap <silent><M-h><M-h> :Leaderf changes<Cr>
elseif Installed('telescope-changes.nvim')
    nnoremap <silent><M-h><M-h> :Telescope changes<Cr>
elseif Installed('coc.nvim')
    nnoremap <silent><M-h><M-h> :CocFzfList changes<Cr>
endif
" --------------------
" browser files all
" --------------------
if InstalledTelescope()
    nnoremap <silent><leader>ff :lcd %:p:h \| Telescope find_files<Cr>
elseif Installed('leaderf')
    let g:Lf_ShortcutF = '<leader>ff'
    nnoremap <silent><leader>ff :lcd %:p:h \| LeaderfFile<Cr>
elseif InstalledFZF()
    nnoremap <silent><leader>ff :lcd %:p:h \| FZF<Cr>
endif
" map config and open file using system browser when has gui
if g:gui_running
    nnoremap <M-o> :tabnew
    nnoremap <M-O> :tabclose<Cr>
    " TabSwitch
    nnoremap <M-n> gt
    nnoremap <M-p> gT
    nnoremap <silent><M-N> :tabm +1<Cr>
    nnoremap <silent><M-P> :tabm -1<Cr>
else
    imap <M-O> <C-o>O
    nmap <M-O> O
endif
if executable('ranger') && UNIX() && g:has_popup_floating
    command! Ranger FloatermNew --wintype=float --position=center --height=0.9 --width=0.9 --name=ranger --autoclose=2 ranger --cmd="cd ./"
    nnoremap <silent>,<Tab> :Ranger<Cr>
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
    nnoremap <silent><M-o> :call OpenBrowser()<Cr>
endif
if Installed('neo-tree.nvim')
    nnoremap <silent><leader><Tab> :NeoTreeFloatToggle<Cr>
    luafile $LUA_PATH/neotree.lua
elseif has('nvim') && Installed('coc.nvim')
    function! CocFile() abort
        exec("CocCommand explorer --toggle --position floating --floating-width " . float2nr(&columns * 0.8) . " --floating-height " . float2nr(&lines * 0.8))
    endfunction
    command! CocFile call CocFile()
    nnoremap <silent><leader><Tab> :CocFile<Cr>
elseif InstalledFZF()
    nnoremap <silent><leader><Tab> :FZFFiles .<Cr>
endif
" --------------------------
" nvim-web-devicons
" --------------------------
if Installed('nvim-web-devicons')
    lua require('nvim-web-devicons').setup({})
endif
" --------------------------
" floaterm-windows
" --------------------------
if Installed('LeaderF-floaterm')
    nnoremap <silent><Tab>w :Leaderf floaterm<Cr>
elseif Installed('fzf-floaterm')
    nnoremap <silent><Tab>w :Floaterms<Cr>
elseif Installed('nvim-notify')
    nnoremap <silent><Tab>w :Telescope floaterm<Cr>
endif
