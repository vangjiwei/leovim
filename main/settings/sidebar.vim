function! s:check_buf_ft(name, nr) abort
    return getwinvar(a:nr, '&filetype') =~ tolower(a:name) || bufname(winbufnr(a:nr)) =~ tolower(a:name)
endfunction
PackAdd 'vim-sidebar-manager'
let g:sidebars = {}
" symbol_tool
if Installed('tagbar')
    function! s:check_tags(nr) abort
        return s:check_buf_ft('tagbar', a:nr)
    endfunction
    let g:sidebars.tags = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_tags'),
                \ 'open': 'TagbarOpen',
                \ 'close': 'TagbarClose'
                \ }
elseif Installed('lspsaga.nvim')
    let g:sidebars.tags = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_buf_ft', ['lspsagaoutline']),
                \ 'open': 'LSoutlineToggle',
                \ 'close': 'LSoutlineToggle'
                \ }
elseif Installed('vista.vim')
    let g:sidebars.tags = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_buf_ft', ['vista']),
                \ 'open': 'Vista ' . get(g:, 'vista_default_executive', ''),
                \ 'close': 'Vista!!'
                \ }
endif
if has_key(g:sidebars, 'tags')
    nnoremap <silent><C-t> :call sidebar#toggle('tags')<CR>
    nnoremap ,t <C-t>
endif
" tree_browser
if Installed('coc.nvim')
    let g:tree_browser = 'coc-explorer'
    function! CocBrowser(type) abort
        if a:type
            exec("CocCommand explorer --no-toggle --width 30 --no-focus")
        else
            exec("CocCommand explorer --toggle")
        endif
    endfunction
    command! CocBrowserOpen  call CocBrowser(1)
    command! CocBrowserClose call CocBrowser(0)
    let g:sidebars.tree_browser = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_buf_ft', ["explorer"]),
                \ 'open': 'CocBrowserOpen',
                \ 'close': 'CocBrowserClose'
                \ }
elseif Installed('neo-tree.nvim')
    let g:tree_browser = 'neo-tree'
    let g:sidebars.tree_browser = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_buf_ft', ["tree"]),
                \ 'open': 'NeoTreeShow',
                \ 'close': 'NeoTreeClose'
                \ }
else
    " --------------------------
    " netrw
    " --------------------------
    PackAdd 'vim-vinegar'
    let g:tree_browser       = 'netrw'
    let g:netrw_altv         = 0
    let g:netrw_banner       = 0
    let g:netrw_liststyle    = 3
    let g:netrw_browse_split = 4
    let g:netrw_winsize      = 16
    function! CloseNetrw()
        try
            let expl_win_num = bufwinnr(t:expl_buf_num)
            if expl_win_num != -1
                let cur_win_nr = winnr()
                exec expl_win_num . 'wincmd w'
                close
                execute winbufnr(cur_win_nr) . "wincmd w"
            endif
        catch /.*/
            " PASS
        endtry
        unlet t:expl_buf_num
    endfunction
    command! CloseNetrw call CloseNetrw()
    function! OpenNetrw()
        Vexplore
        let t:expl_buf_num = bufnr("%")
        execute winnr('#') . "wincmd w"
    endfunction
    command! OpenNetrw call OpenNetrw()
    " toggle
    function! NetrwToggle()
        if exists("t:expl_buf_num")
            CloseNetrw
        else
            OpenNetrw
        endif
    endfunction
    command! NetrwToggle call NetrwToggle()
    function! s:check_netrw(nr) abort
        return s:check_buf_ft('netrw', a:nr)
    endfunction
    let g:sidebars.tree_browser = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_netrw'),
                \ 'open': 'OpenNetrw',
                \ 'close': 'CloseNetrw'
                \ }
endif
nnoremap <silent><C-b> :call sidebar#toggle('tree_browser')<CR>
" undotree
if Installed('undotree')
    function! s:check_undotree(nr) abort
        return s:check_buf_ft('undotree', a:nr)
    endfunction
    let g:sidebars.undotree = {
                \ 'position': 'left',
                \ 'check_win': function('s:check_undotree'),
                \ 'open': 'UndotreeShow',
                \ 'close': 'UndotreeHide'
                \ }
    nnoremap <silent> <leader>U :call sidebar#toggle('undotree')<CR>
endif
" downside
if exists('*win_getid') && has('quickfix')
    function! s:check_quickfix(nr)
        return getwinvar(a:nr, '&filetype') ==# 'qf' && !getwininfo(win_getid(a:nr))[0]['loclist']
    endfunction
    let g:sidebars.quickfix = {
                \ 'position': 'bottom',
                \ 'check_win': function('s:check_quickfix'),
                \ 'open': 'OpenQuickfix',
                \ 'close': 'CloseQuickfix'
                \ }
    nnoremap <silent> <M-d> :call sidebar#toggle('quickfix')<CR>
    if g:has_terminal
        tnoremap <silent> <M-d> <C-\><C-n>:call sidebar#toggle('quickfix')<CR>
    endif
endif
if Installed('vim-terminal-help')
    function! s:check_help()
        return exists('t:__terminal_bid__') ? bufwinnr(t:__terminal_bid__) : 0
    endfunction
    let g:sidebars.terminal = {
                \ 'position': 'bottom',
                \ 'get_win': function('s:check_help'),
                \ 'open': 'call TerminalOpen()',
                \ 'close': 'call TerminalClose()'
                \ }
    nnoremap <silent> <M--> :call sidebar#toggle('terminal')<CR>
    tnoremap <silent> <M--> <C-\><C-n>:call sidebar#toggle('terminal')<CR>
endif
if Installed('vim-flog')
    function! s:check_flog(nr) abort
        return s:check_buf_ft('flog', a:nr)
    endfunction
    let g:sidebars.flog = {
                \ 'position': 'bottom',
                \ 'check_win': function('s:check_flog'),
                \ 'open': 'Flogsplit',
                \ 'close': 'exit'
                \ }
    nnoremap <silent> <M-g> :call sidebar#toggle('flog')<CR>
endif
" startify
let g:startify_session_before_save = ['call sidebar#close_all()']
