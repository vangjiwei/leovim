" ------------------------------
" pairs
" ------------------------------
if Installed('pear-tree')
    let g:pear_tree_map_special_keys = 0
endif
" --------------------------
" git
" --------------------------
if executable('git')
    source $SETTINGS_PATH/git.vim
endif
" --------------------------
" lightline
" --------------------------
try
    set laststatus=2
    PackAdd 'lightline.vim'
    source $SETTINGS_PATH/lightline.vim
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
    cmap <expr> <down> pumvisible() ? '<right>' : '<down>'
    cmap <expr> <up>   pumvisible() ? '<left>'  : '<up>'
    cmap <expr> <C-j>  pumvisible() ? '<right>' : '<C-n>'
    cmap <expr> <C-k>  pumvisible() ? '<left>'  : '<C-p>'
    set wildoptions+=pum
else
    set wildmode=longest,list
    if has('patch-8.2.4500')
        set wildoptions+=pum,fuzzy
    endif
endif
" ------------------------
" home end
" ------------------------
source $SETTINGS_PATH/finder.vim
cmap <C-a> <Home>
cmap <C-e> <End>
imap <expr><C-b> pumvisible()? "\<C-b>":"\<C-o>I"
imap <expr><C-f> pumvisible()? "\<C-f>":"\<C-o>A"
imap <expr><C-a> pumvisible()? "\<C-a>":"\<C-o>I"
" --------------------------
" complete_engine settings
" --------------------------
if InstalledCmp()
    source $SETTINGS_PATH/cmp.vim
elseif Installed('coc.nvim')
    source $SETTINGS_PATH/coc.vim
    if WINDOWS() && isdirectory(expand('~/AppData/Local/nvim-data/mason/bin'))
        let $PATH = expand('~/AppData/Local/nvim-data/mason/bin') . ":" . $PATH
    elseif UNIX() && isdirectory(expand('~/.local/share/nvim/mason/bin'))
        let $PATH = expand('~/.local/share/nvim/mason/bin') . ":" . $PATH
    endif
elseif Installed('vim-mucomplete')
    source $SETTINGS_PATH/mcm.vim
elseif Installed('neocomplcache.vim')
    source $SETTINGS_PATH/ncc.vim
elseif g:complete_engine != 'ncc' && v:version >= 800
    let g:complete_engine = 'apc'
    source $SETTINGS_PATH/apc.vim
else
    let g:complete_engine = 'non'
endif
source $SETTINGS_PATH/snippets.vim
source $SETTINGS_PATH/format.vim
source $SETTINGS_PATH/debug-conf.vim
" --------------------------
" settings
" --------------------------
source $SETTINGS_PATH/differ.vim
source $SETTINGS_PATH/search-replace.vim
source $SETTINGS_PATH/sidebar.vim
source $SETTINGS_PATH/run.vim
source $SETTINGS_PATH/marks.vim
source $SETTINGS_PATH/query.vim
source $SETTINGS_PATH/fold.vim
source $SETTINGS_PATH/yank-paste.vim
source $SETTINGS_PATH/lsp-tag-search.vim
source $SETTINGS_PATH/schemes.vim
source $SETTINGS_PATH/check.vim
" ------------------------
" zfvime is for chs inpus
" ------------------------
source $SETTINGS_PATH/zfvime.vim
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
    let g:which_key_use_floating_win = g:has_popup_float
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
    nnoremap g<Space> :WhichKey "g"<Cr>
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
    nnoremap <M-h> :WhichKey "\<M-h\>"<Cr>
    nnoremap <M-j> :WhichKey "\<M-j\>"<Cr>
    nnoremap <M-k> :WhichKey "\<M-k\>"<Cr>
    nnoremap <M-l> :WhichKey "\<M-l\>"<Cr>
    nnoremap <M-u> :WhichKey "\<M-u\>"<Cr>
    nnoremap <M-c> :WhichKey       "\<M-c\>"<Cr>
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
source $SETTINGS_PATH/autocmd.vim
" --------------------------
" startify
" --------------------------
if get(g:, 'leovim_startify', 1) > 0
    PackAdd 'vim-startify'
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
" save
" ------------------------
nnoremap <M-s> :w!<Cr>
cnoremap <M-s> w!<Cr>
inoremap <M-s> <C-o>:w!<Cr>
xnoremap <M-s> <ESC>:w!<Cr>
nnoremap <M-S> :wa!<Cr>
cnoremap <M-S> wa!<Cr>
inoremap <M-S> <C-o>:wa!<Cr>
xnoremap <M-S> <ESC>:wa!<Cr>
" ------------------------
" c-g as <ESC>
" ------------------------
xnoremap <C-g> <ESC>
snoremap <C-g> <ESC>
" ------------------------
" close and quit
" ------------------------
nnoremap <silent><leader>q    :q!<Cr>
nnoremap <silent><leader><BS> :qall!<Cr>
inoremap <M-q> <ESC>
xnoremap <M-q> <ESC>
cnoremap <M-q> <ESC>
function! ConfirmQuit() abort
    if index(['help', 'gitcommit', ''], &ft) >= 0
        q!
    elseif expand('%') == ''
        q!
    elseif &ma == 0
        q!
    else
        try
            if getbufinfo('%')[0].changed
                let l:confirmed = confirm('Do you really want to `Both save and quit` or `quit only`?', "&Both\n&Yes\n&No", 3)
                if l:confirmed <= 2
                    if l:confirmed == 1
                        wq!
                    else
                        q!
                    endif
                end
            else
                let l:confirmed = confirm('Do you really want to `quit`?', "&Yes\n&No", 2)
                if l:confirmed == 1
                    q!
                end
            endif
        catch
            q!
        endtry
    endif
endfun
command! ConfirmQuit call ConfirmQuit()
nnoremap <silent><M-q> :ConfirmQuit<Cr>
" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
let loaded_bclose = 1
if !exists('bclose_multiple')
    let bclose_multiple = 1
endif
" Display an error message.
function! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
endfunction
function! s:Bclose(bang, buffer)
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif
    if btarget < 0
        call s:Warn('No matching buffer for '.a:buffer)
        return
    endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
        return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    if !g:bclose_multiple && len(wnums) > 1
        call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
        return
    endif
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
            buffer #
        else
            bprevious
        endif
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else
                execute 'enew'.a:bang
            endif
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
nnoremap <silent> Q :Bclose<CR>
xnoremap <silent> Q <ESC>
" kill other BD
command! BdOther silent! execute "%bd|e#|bd#"
nnoremap <silent><leader>Q :BdOther<Cr>
" ------------------------
" edit start.vim
" ------------------------
nnoremap <leader>e<Cr> :source $LEOVIM_PATH/start.vim<Cr>
" ------------------------
" open config file
" ------------------------
nnoremap <leader>es :tabe $LEOVIM_PATH/start.vim<Cr>
nnoremap <leader>el :tabe $HOME/.vimrc.local<Cr>
nnoremap <leader>eb :tabe $SETTINGS_PATH/boostup.vim<Cr>
nnoremap <leader>ec :tabe $MAIN_PATH/common.vim<Cr>
nnoremap <leader>eu :tabe ~/.leovim.conf/main/settings/lua/
nnoremap <leader>er :tabe ~/.leovim.conf/runtime/
nnoremap <leader>em :tabe ~/.leovim.conf/main/
" ------------------------
" open ide config files
" ------------------------
nnoremap <leader>ej :tabe $LEOVIM_PATH/jetbrains/idea.vim<Cr>
nnoremap <leader>en :tabe $LEOVIM_PATH/vscode/neovim.vim<Cr>
nnoremap <leader>ek :tabe $LEOVIM_PATH/vscode/keybindings.json<Cr>
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
" set filetype unix and trim \r
nnoremap <leader>ef :set ff=unix<Cr>:%s/\r//g<Cr>
" --------------------------
" M-key map
" --------------------------
if get(g:, 'leovim_loaded', 0) == 0 && !has('nvim') && g:gui_running == 0
    function! s:metacode(key)
        exec "set <M-".a:key.">=\e".a:key
    endfunction
    for i in range(26)
        " 97 is ascii of a
        call s:metacode(nr2char(97 + i))
        " 65 is ascii of A
        call s:metacode(nr2char(65 + i))
    endfor
    for i in range(10)
        call s:metacode(nr2char(char2nr('0') + i))
    endfor
    for c in [",", ".", ";", ":", "/", "?", "-", "_", "{", "}", "=", "+", "'"]
        call s:metacode(c)
    endfor
endif
imap <M-{> <C-o><M-{>
imap <M-}> <C-o><M-}>
imap <M-,> <C-o><M-,>
imap <M-.> <C-o><M-.>
imap <M-/> <C-o><M-/>
imap <M-?> <C-o><M-?>
imap <M-;> <C-o><M-;>
imap <M-:> <C-o><M-:>
" ------------------------
" after config
" ------------------------
nnoremap <leader>ea :tabe ~/.vimrc.after<Cr>
if filereadable(expand('~/.vimrc.after'))
    source ~/.vimrc.after
endif
