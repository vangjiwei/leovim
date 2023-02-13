" --------------------------
" git
" --------------------------
if executable('git')
    source $CONFIG_PATH/git.vim
endif
" ------------------------------
" pairs
" ------------------------------
if Installed('pear-tree')
    let g:pear_tree_map_special_keys = 0
endif
" --------------------------
" lightline
" --------------------------
try
    set laststatus=2
    PackAdd 'lightline.vim'
    source $CONFIG_PATH/lightline.vim
catch
    let g:currentmode={
                \ 'n':      'NORMAL ',
                \ 'v':      'VISUAL ',
                \ 'V':      'V·Line ',
                \ "\<C-V>": 'V·Block ',
                \ 'i':      'INSERT ',
                \ 'R':      'R ',
                \ 'Rv':     'V·Replace ',
                \ 'c':      'Command ',
                \}
    set statusline=
    " show full file path
    set statusline+=%F
    " show current line number
    set statusline+=%l
    set statusline+=\ %{toupper(g:currentmode[mode()])}
    set statusline+=%{&modified?'[+]':''}
    set statusline+=%-7([%{&fileformat}]%)
    set statusline+=%#Warnings#
    set statusline+=%{&bomb?'[BOM]':''}
    set statusline+=%{&filetype!=#''?&filetype.'\ ':'none\ '}
    set statusline+=%2p%%
    hi User1 ctermfg=0 ctermbg=114
    hi User2 ctermfg=114 ctermbg=0
endtry
" -----------------------------------
" menu
" -----------------------------------
set wildmenu
if has('nvim')
    set wildoptions+=pum
else
    try
        set wildmode=full
        try
            set wildoptions+=fuzzy
            set wildoptions+=pum
        catch
            set wildmode=longest,list
        endtry
    catch
        set wildmode=longest,list
    endtry
endif
if Installed('wilder.nvim')
    set wildcharm=<C-z>
    call wilder#enable_cmdline_enter()
    call wilder#setup({'modes': [':', '/', '?']})
    let s:highlighters = [
                \ wilder#pcre2_highlighter(),
                \ wilder#basic_highlighter(),
                \ ]
    call wilder#set_option('renderer', wilder#renderer_mux({
                \ ':': wilder#popupmenu_renderer({
                \   'highlighter': s:highlighters,
                \ }),
                \ '/': wilder#wildmenu_renderer({
                \   'highlighter': s:highlighters,
                \ }),
                \ '?': wilder#wildmenu_renderer({
                \   'highlighter': s:highlighters,
                \ }),
                \ }))
    cmap <expr><C-n>   wilder#in_context() ? wilder#next()     : "\<C-n>"
    cmap <expr><C-p>   wilder#in_context() ? wilder#previous() : "\<C-p>"
    cmap <expr><Tab>   wilder#in_context() ? wilder#next()     : "\<Tab>"
    cmap <expr><S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
    " todo , add winder status echo
    cmap <silent><M-w> <C-u>call wilder#toggle()<Cr>
else
    cmap <M-w> <Esc>
endif
" ------------------------
" home end
" ------------------------
source $CONFIG_PATH/finder.vim
cmap <C-a> <Home>
cmap <C-e> <End>
imap <expr><C-b> pumvisible()? "\<C-b>":"\<C-o>I"
imap <expr><C-f> pumvisible()? "\<C-f>":"\<C-o>A"
imap <expr><C-a> pumvisible()? "\<C-a>":"\<C-o>0"
" --------------------------
" complete_engine settings
" --------------------------
if Installed('coc.nvim')
    source $CONFIG_PATH/coc.vim
elseif InstalledCmp()
    source $CONFIG_PATH/cmp.vim
elseif Installed('vim-mucomplete')
    source $CONFIG_PATH/mcm.vim
elseif g:complete_engine != 'non' && v:version >= 800
    let g:complete_engine = 'apc'
    source $CONFIG_PATH/apc.vim
else
    let g:complete_engine = 'non'
endif
source $CONFIG_PATH/snippets.vim
source $CONFIG_PATH/format.vim
source $CONFIG_PATH/debug.vim
" --------------------------
" settings
" --------------------------
source $CONFIG_PATH/differ.vim
source $CONFIG_PATH/search-replace.vim
source $CONFIG_PATH/sidebar.vim
source $CONFIG_PATH/run.vim
source $CONFIG_PATH/marks.vim
source $CONFIG_PATH/query.vim
source $CONFIG_PATH/fold.vim
source $CONFIG_PATH/yank-paste.vim
source $CONFIG_PATH/lsp-tag-search.vim
source $CONFIG_PATH/schemes.vim
source $CONFIG_PATH/check.vim
" ------------------------
" zfvime is for chs input
" ------------------------
source $CONFIG_PATH/zfvime.vim
" --------------------------
" whichkey
" --------------------------
if has('patch-7.4.330') && get(g:, 'which_key_type', 'vim') == ''
    echo "which key is disabled"
elseif has('nvim') && get(g:, 'which_key_type', 'vim') == 'nvim'
    PackAdd 'which-key.nvim'
    luafile $LUA_PATH/which-key.lua
elseif has('patch-7.4.330')
    let g:which_key_type = 'vim'
    if v:version >= 800
        PackAdd 'vim-which-key'
    else
        PackAdd 'vim-which-key-legacy'
    endif
    let g:which_key_group_dicts      = ''
    let g:which_key_use_floating_win = g:has_popup_floating
    " basic keys
    nnoremap <Space> :WhichKey       " "<Cr>
    nnoremap <Tab>   :WhichKey       "\<Tab\>"<Cr>
    nnoremap ,       :WhichKey       ","<Cr>
    nnoremap \       :WhichKey       "\\"<Cr>
    nnoremap [       :WhichKey       "["<Cr>
    nnoremap ]       :WhichKey       "]"<Cr>
    xnoremap <Space> :WhichKeyVisual " "<Cr>
    xnoremap <Tab>   :WhichKeyVisual "\<Tab\>"<Cr>
    xnoremap ,       :WhichKeyVisual ","<Cr>
    xnoremap \       :WhichKeyVisual "\\"<Cr>
    xnoremap [       :WhichKeyVisual "["<Cr>
    xnoremap ]       :WhichKeyVisual "]"<Cr>
    " gszc whichkey
    if g:complete_engine == 'cmp'
        nnoremap g<Space> :map g<Cr>
    else
        nnoremap g<Space> :WhichKey "g"<Cr>
    endif
    nnoremap m<Space> :WhichKey "m"<Cr>
    nnoremap s<Space> :WhichKey "s"<Cr>
    nnoremap S<Space> :WhichKey "S"<Cr>
    nnoremap c<Space> :WhichKey "c"<Cr>
    nnoremap z<Space> :WhichKey "z"<Cr>
    nnoremap Z<Space> :WhichKey "Z"<Cr>
    " C-f
    nnoremap <C-f> :WhichKey "\<C-f\>"<Cr>
    xnoremap <C-f> :WhichKeyVisual "\<C-f\>"<Cr>
    " M- keys
    nnoremap <M-g> :WhichKey "\<M-g\>"<Cr>
    nnoremap <M-j> :WhichKey "\<M-j\>"<Cr>
    nnoremap <M-k> :WhichKey "\<M-k\>"<Cr>
    nnoremap <M-l> :WhichKey "\<M-l\>"<Cr>
    nnoremap <M-h> :WhichKey "\<M-h\>"<Cr>
    nnoremap <M-c> :WhichKey "\<M-c\>"<Cr>
    xnoremap <M-c> :WhichKeyVisual "\<M-c\>"<Cr>
    if get(g:, 'debug_tool', '') != ''
        nnoremap <M-m> :WhichKey "\<M-m\>"<Cr>
        nnoremap <M-d> :WhichKey "\<M-d\>"<Cr>
    endif
else
    let g:which_key_type = ''
endif
" --------------------------
" show impport config
" --------------------------
function! s:getVimVersion()
    let l:result=[]
    if has('nvim')
        if g:gui_running
            call add(l:result, 'gnvim-')
        else
            call add(l:result, 'nvim-')
        endif
        let v = api_info().version
        call add(l:result, printf('%d.%d.%d', v.major, v.minor, v.patch))
    else
        if g:gui_running
            call add(l:result, 'gvim-')
        else
            call add(l:result, 'vim-')
        endif
        redir => l:msg | silent! execute ':version' | redir END
        call add(l:result, matchstr(l:msg, 'VIM - Vi IMproved\s\zs\d.\d\ze'))
        call add(l:result, '.')
        call add(l:result, matchstr(l:msg, '\v\zs\d{1,5}\ze\n'))
    endif
    return join(l:result, "")
endfunction
function! Version()
    let params_dict = {
                \ 'version':         s:getVimVersion(),
                \ 'python':          g:python_version,
                \ 'tree_browser':    g:tree_browser,
                \ 'colors_name':     g:colors_name,
                \ 'pack_tool':       g:pack_tool,
                \ 'complete_engine': g:complete_engine
                \ }
    if get(g:, 'python_exe_path', '') != ''
        let params_dict['python_exe_path'] = g:python_exe_path
    endif
    if get(g:, 'fuzzy_finder', '') != ''
        let params_dict['fuzzy_finder'] = g:fuzzy_finder
    endif
    if get(g:, 'complete_snippets', '') != ''
        let params_dict['complete_snippets'] = g:complete_snippets
    endif
    if get(g:, 'search_tool', '') != ''
        let params_dict['search_tool'] = g:search_tool
    endif
    if get(g:, 'debug_tool', '') != ''
        let params_dict['debug_tool'] = g:debug_tool
    endif
    if get(g:, 'terminal_plus', '') != ''
        let params_dict['terminal_plus'] = g:terminal_plus
    endif
    if get(g:, 'symbol_tool', '') != ''
        let params_dict['symbol_tool'] = g:symbol_tool
    endif
    if get(g:, 'check_tool', '') != ''
        let params_dict['check_tool'] = g:check_tool
    endif
    if get(g:, 'input_method', '') != ''
        let params_dict['input_method'] = g:input_method
    endif
    if has('nvim') && exists('$TERM') && $TERM != ''
        let params_dict['term'] = $TERM
    elseif !has('nvim') && exists('&term') && &term != ''
        let params_dict['term'] = &term
    endif
    echo string(params_dict)
endfunction
command! Version call Version()
nnoremap <M-k>v :Version<Cr>
nnoremap <M-k>V :version<Cr>
" --------------------------
" autocmd
" --------------------------
source $CONFIG_PATH/autocmd.vim
" --------------------------
" startify
" --------------------------
if get(g:, 'leovim_startify', 1) > 0
    PackAdd 'vim-startify', {'opt': 1}
    autocmd User Startified setlocal buflisted
    let g:startify_custom_header = [
                \ '        LLLLLLLLLLL             EEEEEEEEEEEEEEEEEEEEEE     OOOOOOOOO     VVVVVVVV           VVVVVVVVIIIIIIIIIIMMMMMMMM               MMMMMMMM ',
                \ '        L:::::::::L             E::::::::::::::::::::E   OO:::::::::OO   V::::::V           V::::::VI::::::::IM:::::::M             M:::::::M ',
                \ '        L:::::::::L             E::::::::::::::::::::E OO:::::::::::::OO V::::::V           V::::::VI::::::::IM::::::::M           M::::::::M ',
                \ '        LL:::::::LL             EE::::::EEEEEEEEE::::EO:::::::OOO:::::::OV::::::V           V::::::VII::::::IIM:::::::::M         M:::::::::M ',
                \ '          L:::::L                 E:::::E       EEEEEEO::::::O   O::::::O V:::::V           V:::::V   I::::I  M::::::::::M       M::::::::::M ',
                \ '          L:::::L                 E:::::E             O:::::O     O:::::O  V:::::V         V:::::V    I::::I  M:::::::::::M     M:::::::::::M ',
                \ '          L:::::L                 E::::::EEEEEEEEEE   O:::::O     O:::::O   V:::::V       V:::::V     I::::I  M:::::::M::::M   M::::M:::::::M ',
                \ '          L:::::L                 E:::::::::::::::E   O:::::O     O:::::O    V:::::V     V:::::V      I::::I  M::::::M M::::M M::::M M::::::M ',
                \ '          L:::::L                 E:::::::::::::::E   O:::::O     O:::::O     V:::::V   V:::::V       I::::I  M::::::M  M::::M::::M  M::::::M ',
                \ '          L:::::L                 E::::::EEEEEEEEEE   O:::::O     O:::::O      V:::::V V:::::V        I::::I  M::::::M   M:::::::M   M::::::M ',
                \ '          L:::::L                 E:::::E             O:::::O     O:::::O       V:::::V:::::V         I::::I  M::::::M    M:::::M    M::::::M ',
                \ '          L:::::L         LLLLLL  E:::::E       EEEEEEO::::::O   O::::::O        V:::::::::V          I::::I  M::::::M     MMMMM     M::::::M ',
                \ '        LL:::::::LLLLLLLLL:::::LEE::::::EEEEEEEE:::::EO:::::::OOO:::::::O         V:::::::V         II::::::IIM::::::M               M::::::M ',
                \ '        L::::::::::::::::::::::LE::::::::::::::::::::E OO:::::::::::::OO           V:::::V          I::::::::IM::::::M               M::::::M ',
                \ '        L::::::::::::::::::::::LE::::::::::::::::::::E   OO:::::::::OO              V:::V           I::::::::IM::::::M               M::::::M ',
                \ '        LLLLLLLLLLLLLLLLLLLLLLLLEEEEEEEEEEEEEEEEEEEEEE     OOOOOOOOO                 VVV            IIIIIIIIIIMMMMMMMM               MMMMMMMM ',
                \ ]
    let g:startify_files_number   = 10
    let g:startify_session_number = 10
    let g:startify_list_order = [
                \ ['   最近项目:'],
                \ 'sessions',
                \ ['   最近文件:'],
                \ 'files',
                \ ['   快捷命令:'],
                \ 'commands',
                \ ['   常用书签:'],
                \ 'bookmarks',
                \ ]
    let g:startify_commands = [
                \ {'v': ['重要插件', 'call Version()']},
                \ {'V': ['基本信息', 'version']},
                \ ]
    if has('nvim')
        let g:startify_session_dir = expand("~/.leovim.d/session.nvim")
    else
        let g:startify_session_dir = expand("~/.leovim.d/session.vim")
    endif
    if !isdirectory(g:startify_session_dir)
        silent! call mkdir(g:startify_session_dir, "p")
    endif
    nnoremap <leader>st :Startify<Cr>
    nnoremap <leader>sv :SSave<Space>
    nnoremap <leader>sl :SLoad<Space>
    nnoremap <leader>sd :SDelete<Space>
endif
" ------------------------
" open ide config files
" ------------------------
nnoremap <leader>ej :tabe $LEOVIM_PATH/jetbrains/idea.vim<Cr>
nnoremap <leader>en :tabe $LEOVIM_PATH/vscode/neovim.vim<Cr>
nnoremap <leader>ek :tabe $LEOVIM_PATH/vscode/keybindings.json<Cr>
" --------------------------
" IDE integration
" --------------------------
function! s:getBookmarkUnderCursor(text, pos)
    " Find the start location
    let p = a:pos
    while p >= 0 && a:text[p] =~ '\f'
        let p = p - 1
    endwhile
    let p = p + 1
    " Match file name and position
    let l:m = matchlist(a:text, '\v(\f+)%([#:](\d+))?%(:(\d+))?', p)
    if len(l:m) > 0
        return [l:m[1], l:m[2], l:m[3]]
    endif
    return []
endfunc
function! s:OpenFileLinkInIde(text, pos, ide)
    let l:location = s:getBookmarkUnderCursor(a:text, a:pos)
    if a:ide == 'code'
        let ide = 'code --goto'
    else
        let ide = a:ide
    endif
    " location 0: file, 1: line, 2: column
    if l:location[0] != ''
        if l:location[1] != ''
            if l:location[2] != ''
                if ide =~ 'code'
                    let l:command = ide . " " . l:location[0] . ":" . str2nr(l:location[1]) . ":" . str2nr(l:location[2])
                else
                    let l:command = ide . " --column " . str2nr(l:location[2]) . " " . l:location[0] . ":" . str2nr(l:location[1])
                endif
                if Installed('asyncrun.vim')
                    exec "AsyncRun -silent " . l:command
                else
                    exec "! " . l:command
                endif
            else
                let l:command = ide . " " . l:location[0] . ":" . str2nr(l:location[1])
                if Installed('asyncrun.vim')
                    exec "AsyncRun -silent " . l:command
                else
                    exec "! " . l:command
                endif
            endif
        else
            let l:command = ide . " " . l:location[0]
            if Installed('asyncrun.vim')
                exec "AsyncRun -silent " . l:command
            else
                exec "! " . l:command
            endif
        endif
    else
        echo "Not a valid file path"
    endif
endfunc
if executable('idea64') && Require('idea')
    command! OpenFileLinkInIdea call s:OpenFileLinkInIde(getline("."), col("."), "idea64")
    nnoremap <leader>eI :OpenFileLinkInIdea<cr>
    if Installed('asyncrun.vim')
        nnoremap <leader>ei :<c-r>=printf("AsyncRun -silent idea64 --line %d %s", line("."), expand("%:p"))<cr><cr>
    else
        nnoremap <leader>ei :<c-r>=printf("!idea64 --line %d %s", line("."), expand("%:p"))<cr><cr>
    endif
endif
if executable('code') && Require('vscode')
    command! OpenFileLinkInVSCode call s:OpenFileLinkInIde(getline("."), col("."), "code")
    nnoremap <leader>eV :OpenFileLinkInVSCode<cr>
    if Installed('asyncrun.vim')
        nnoremap <leader>ev :<c-r>=printf("AsyncRun -silent code --goto %s:%d", expand("%:p"), line("."))<cr><cr>
    else
        nnoremap <leader>ev :<c-r>=printf("!code --goto %s:%d", expand("%:p"), line("."))<cr><cr>
    endif
endif
" ------------------------
" cp keybindings.json
" ------------------------
if exists("g:vscode_keybindings_dir") && isdirectory(g:vscode_keybindings_dir)
    function s:copykeybindings() abort
        if WINDOWS()
            let cmd = "!xcopy %s %s /Y"
        else
            let cmd = "!cp -f %s %s"
        endif
        let cmd = printf(cmd, expand("$LEOVIM_PATH/vscode/keybindings.json"),  expand(g:vscode_keybindings_dir))
        execute(cmd)
    endfunction
    command! CopyKeybindings call s:copykeybindings()
    nnoremap <leader>eK :CopyKeybindings<Cr>
endif
