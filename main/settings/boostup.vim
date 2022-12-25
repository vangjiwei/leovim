" --------------------------
" basic functions
" --------------------------
function! TripTrailingWhiteSpace()
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ""
    endif
    let lines[-1] = lines[-1][:column_end - (&selection == "inclusive" ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
function! Has_Back_Space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction
function! FileReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction
" --------------------------
" Execute function
" --------------------------
function! Execute(cmd)
    let cmd = a:cmd
    redir => l:output
    silent! execute cmd
    redir END
    return l:output
endfunction
" --------------------------
" GetPyxVersion
" --------------------------
function! GetPyxVersion()
    if CYGWIN()
        return 0
    endif
    if has('python3')
        let l:pyx_version_raw = Execute('py3 print(sys.version)')
    elseif has('python')
        let l:pyx_version_raw = Execute('py print(sys.version)')
    else
        return 0
    endif
    let l:pyx_version_raw = matchstr(l:pyx_version_raw, '\v\zs\d{1,}.\d{1,}.\d{1,}\ze')
    if l:pyx_version_raw == ''
        return 0
    endif
    let l:pyx_version = StringToFloat(l:pyx_version_raw)
" --------------------------
" python import
" --------------------------
    if l:pyx_version > 3
        python3 << Python3EOF
try:
    import vim
    import pygments
except Exception:
    pass
else:
    vim.command('let g:pygments_import = 1')
try:
    import vim
    import tagls
except Exception:
    pass
else:
    vim.command('let g:tagls_import = 1')
Python3EOF
    endif
    return l:pyx_version
endfunction
" ------------------------------
" node_version
" ------------------------------
if executable('node') && executable('npm')
    let s:node_version_raw = matchstr(system('node --version'), '\vv\zs\d{1,4}.\d{1,4}\ze')
    let s:node_version = StringToFloat(s:node_version_raw)
    if s:node_version >= 14.14
        if executable('yarn')
            let s:yarn_version_raw = system('yarn --version')
            let s:yarn_version = StringToFloat(s:yarn_version_raw)
            if s:yarn_version >= 1.2218
                let g:node_version = 'advanced'
            else
                let g:node_version = 'basic'
            endif
        else
            let g:node_version = 'basic'
        endif
    else
        let g:node_version = ''
    endif
else
    let g:node_version = ''
endif
" ------------------------------
" ctags_type
" ------------------------------
if WINDOWS() && Require('tags') || UNIX()
    if WINDOWS()
        let g:ctags_type = 'Universal-json'
    elseif executable('ctags') && has('patch-7.4.330')
        let g:ctags_type = system('ctags --version')[0:8]
        if g:ctags_type == 'Universal'
            if system('ctags --list-features | grep json') =~ 'json'
                let g:ctags_type = 'Universal-json'
            endif
        endif
    else
        let g:ctags_type = ''
    endif
else
    let g:ctags_type = ''
endif
" --------------------------
" set TERM && screen
" --------------------------
if WINDOWS()
    if isdirectory($HOME . "\\.leovim.windows") && get(g:,'leovim_loaded',0) == 0
        let $PATH = $HOME  . "\\.leovim.windows\\tools;" . $HOME  . "\\.leovim.windows\\gtags\\bin;" . $HOME  . "\\.leovim.windows\\cppcheck;" . $PATH
    endif
    set winaltkeys=no
    if g:gui_running
        set lines=999
        set columns=999
    endif
    if has('libcall') && !has('nvim') && g:gui_running
        let g:gvimfullscreendll = $HOME ."\\.leovim.windows\\tools\\gvimfullscreen.dll"
        function! ToggleFullScreen()
            call libcallnr(g:gvimfullscreendll, "ToggleFullScreen", -1)
        endfunction
        nnoremap <C-cr> <ESC>:call ToggleFullScreen()<Cr>
        let g:VimAlpha = 255
        function! SetAlpha(alpha)
            let g:VimAlpha = g:VimAlpha + a:alpha
            if g:VimAlpha < 95
                let g:VimAlpha = 95
            endif
            if g:VimAlpha > 255
                let g:VimAlpha = 255
            endif
            call libcall(g:gvimfullscreendll, 'SetAlpha', g:VimAlpha)
        endfunction
        nnoremap <silent> <M-\>  :call SetAlpha(5)<Cr>
        nnoremap <silent> <M-\|> :call SetAlpha(-5)<Cr>
    endif
else
    let $PATH = $LEOVIM_PATH . "/bin:" . $PATH
    " --------------------------
    " terminal comparability
    " --------------------------
    set t_ut=
    if exists('+t_TI') && exists('+t_TE')
        let &t_TI = ''
        let &t_TE = ''
    endif
    if exists('+t_RS') && exists('+t_SH')
        let &t_RS = ''
        let &t_SH = ''
    endif
    if has('nvim') && $TMUX != ''
        let $TERM = "xterm-256color"
    elseif g:gui_running == 0 && !has('nvim')
        if $TMUX != ''
            try
                set term=xterm-256color
            catch
                set term=$TERM
            endtry
        else
            set term=$TERM
        endif
    endif
endif
" ------------------------
" has_truecolor
" ------------------------
if get(g:, 'has_truecolor', 1) != 0 && (has('termguicolors') || WINDOWS() || g:gui_running)
    try
        set termguicolors
        hi LineNr ctermbg=NONE guibg=NONE
        nnoremap <M-k>g :set notermguicolors! notermguicolors?<Cr>
        let g:has_truecolor = 1
        if !has('nvim')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
    catch
        let g:has_truecolor = 0
    endtry
else
    let g:has_truecolor = 0
endif
" --------------------------
" TMUX config, must writen after packopt.vim for Alt_to_meta function
" --------------------------
if $TMUX != ''
    set ttimeoutlen=30
elseif &ttimeoutlen > 60 || &ttimeoutlen <= 0
    set ttimeoutlen=60
endif
set timeout
set ttimeout
set timeoutlen=300
set updatetime=200
if g:gui_running == 0
    let g:tmux_navigator_no_mappings = 1
    PackAdd 'vim-tmux-navigator'
    nnoremap <silent><M-H> :TmuxNavigateLeft<cr>
    nnoremap <silent><M-L> :TmuxNavigateRight<cr>
    nnoremap <silent><M-J> :TmuxNavigateDown<cr>
    nnoremap <silent><M-K> :TmuxNavigateUp<cr>
    inoremap <silent><M-H> <C-o>:TmuxNavigateLeft<cr>
    inoremap <silent><M-L> <C-o>:TmuxNavigateRight<cr>
    inoremap <silent><M-J> <C-o>:TmuxNavigateDown<cr>
    inoremap <silent><M-K> <C-o>:TmuxNavigateUp<cr>
    if g:has_terminal
        tnoremap <silent><M-H> <C-\><C-n>:TmuxNavigateLeft<cr>
        tnoremap <silent><M-L> <C-\><C-n>:TmuxNavigateRight<cr>
        tnoremap <silent><M-J> <C-\><C-n>:TmuxNavigateDown<cr>
        tnoremap <silent><M-K> <C-\><C-n>:TmuxNavigateUp<cr>
        tnoremap <silent><C-w><C-w> <C-\><C-n>:TmuxNavigatePrevious<cr>
    endif
else
    nnoremap <M-H> <C-w><C-h>
    nnoremap <M-L> <C-w><C-l>
    nnoremap <M-J> <C-w><C-j>
    nnoremap <M-K> <C-w><C-k>
    inoremap <M-H> <C-o><C-w><C-h>
    inoremap <M-L> <C-o><C-w><C-l>
    inoremap <M-J> <C-o><C-w><C-j>
    inoremap <M-K> <C-o><C-w><C-k>
    if g:has_terminal
        tnoremap <M-H> <C-\><C-n><C-w><C-h>
        tnoremap <M-L> <C-\><C-n><C-w><C-l>
        tnoremap <M-J> <C-\><C-n><C-w><C-j>
        tnoremap <M-K> <C-\><C-n><C-w><C-k>
        tnoremap <C-w><C-w> <C-\><C-n><C-w><C-w>
    endif
endif
nmap <M-j>s <C-w>f
nmap <M-j>t <C-w>f<C-w>T
nmap <M-j>v <C-w>f<C-w>L
imap <M-O> <C-o>O
nmap <M-O> O
nmap <M-A> ggVG
" ------------------------
" second window
" ------------------------
function! Tools_PreviousCursor(mode)
    if winnr('$') <= 1
        return
    endif
    noautocmd silent! wincmd p
    if a:mode == 'quit'
        exec "normal! \<C-w>q"
    elseif a:mode == 'ctrlo'
        exec "normal! \<C-o>"
    elseif a:mode == 'ctrlu'
        exec "normal! \<C-u>"
    elseif a:mode == 'ctrld'
        exec "normal! \<C-d>"
    elseif a:mode == 'ctrle'
        exec "normal! \<C-e>"
    elseif a:mode == 'ctrly'
        exec "normal! \<C-y>"
    elseif a:mode == 'ctrli'
        exec "normal! \<C-i>"
    elseif a:mode == 'ctrlm'
        exec "normal! \<C-m>"
    elseif a:mode == 'ctrlh'
        exec "normal! \<C-h>"
    elseif a:mode == 'ctrlj'
        exec "normal! \<C-j>"
    elseif a:mode == 'ctrlk'
        exec "normal! \<C-k>"
    elseif a:mode == 'ctrll'
        exec "normal! \<C-l>"
    else
        return
    endif
    noautocmd silent! wincmd p
endfunction
nnoremap <silent><M-Q> :call Tools_PreviousCursor('quit')<Cr>
nnoremap <silent><M-U> :call Tools_PreviousCursor('ctrlu')<Cr>
nnoremap <silent><M-D> :call Tools_PreviousCursor('ctrld')<Cr>
nnoremap <silent><M-E> :call Tools_PreviousCursor('ctrle')<Cr>
nnoremap <silent><M-Y> :call Tools_PreviousCursor('ctrly')<Cr>
inoremap <silent><M-Q> <C-o>:call Tools_PreviousCursor('quit')<Cr>
inoremap <silent><M-U> <C-o>:call Tools_PreviousCursor('ctrlu')<Cr>
inoremap <silent><M-D> <C-o>:call Tools_PreviousCursor('ctrld')<Cr>
inoremap <silent><M-E> <C-o>:call Tools_PreviousCursor('ctrle')<Cr>
inoremap <silent><M-Y> <C-o>:call Tools_PreviousCursor('ctrly')<Cr>
" --------------------------
" python_support
" --------------------------
let g:python3_host_prog = get(g:, 'python3_host_prog', '')
let g:python_host_prog  = get(g:, 'python_host_prog', '')
let g:python_version = get(g:, 'python_version', GetPyxVersion())
" --------------------------
" set python_host_prog
" --------------------------
if g:python_version > 3
    if g:python3_host_prog == ''
        if WINDOWS() && !has('nvim')
            try
                let g:python3_host_prog = exepath('python3')
                if get(g:, 'python3_host_prog', '') == ''
                    let g:python3_host_prog = exepath('python')
                endif
            catch
                let g:python3_host_prog = exepath('python')
            endtry
        elseif v:version >= 800
            let g:python3_host_prog = exepath('python3')
            if get(g:, 'python3_host_prog', '') == ''
                let g:python3_host_prog = exepath('python')
            endif
        else
            let g:python3_host_prog = system('which python3')
        endif
    endif
    let g:python_exe_path = g:python3_host_prog
    let $PYTHONUNBUFFERED=1
elseif g:python_version > 2
    if g:python_host_prog == ''
        if WINDOWS() && !has('nvim')
            try
                let g:python_host_prog = exepath('python2')
                if get(g:, 'python_host_prog', '') == ''
                    let g:python_host_prog = exepath('python')
                endif
            catch
                let g:python_host_prog = exepath('python')
            endtry
        elseif v:version >= 800
            let g:python_host_prog = exepath('python')
            if get(g:, 'python_host_prog', '') == ''
                let g:python_host_prog = exepath('python')
            endif
        else
            let g:python_host_prog = system('which python')
        endif
    endif
    let g:python_exe_path = g:python_host_prog
    let $PYTHONUNBUFFERED=1
else
    let g:python_exe_path = ''
endif
" ------------------------
" remap for cusor move insert mode
" ------------------------
inoremap <M-l> <Right>
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
" ------------------------
" WB
" ------------------------
nmap <M-b> b
xmap <M-b> b
imap <M-b> <C-o>b
nmap <M-f> e
xmap <M-f> e
imap <M-f> <C-o>e
cmap <M-b> <C-left>
cmap <M-f> <C-right>
" ------------------------
" tab is used as a leaderkey
" ------------------------
nnoremap <Tab><Tab> <Tab>
" ------------------------
" panel jump
" ------------------------
nnoremap <Tab>H <C-w>H
nnoremap <Tab>J <C-w>J
nnoremap <Tab>K <C-w>K
nnoremap <Tab>L <C-w>L
" open in vsplit/split/tab
nnoremap <Tab>v       :vsplit<Space>
nnoremap <Tab>s       :split<Space>
nnoremap <Tab><Space> :tabe<space>
" ------------------------
" basic toggle and show
" ------------------------
nnoremap <leader>n :set relativenumber \| set number<Cr>
nnoremap <M-k>n :set nonu! nonu?<Cr>
nnoremap <M-k>r :set norelativenumber \| set nonumber<Cr>
nnoremap <M-k>f :set nofoldenable! nofoldenable?<Cr>
nnoremap <M-k>w :set nowrap! nowrap?<Cr>
nnoremap <M-k>h :set nohlsearch? nohlsearch!<Cr>
nnoremap <M-k>i :set invrelativenumber<Cr>
nnoremap <M-k>s :colorscheme<Space>
nnoremap <M-k>t :setfiletype<Space>
nnoremap <M-'>  :registers<Cr>
" ------------------------
" buffers mark messages
" ------------------------
nnoremap <leader>b :ls<Cr>
nnoremap <C-f>m    :marks<Cr>
nnoremap ,m        :messages<Cr>
" ------------------------
" tab control
" ------------------------
set tabpagemax=10
set showtabline=2
nnoremap <M-W> :tabonly<Cr>
xnoremap <M-W> <ESC>:tabonly<Cr>
nnoremap <silent> <Tab>1 :tabm 0<Cr>
nnoremap <silent> <Tab>0 :tabm<Cr>
nnoremap <silent> <M-1>  :tabn1<Cr>
nnoremap <silent> <M-2>  :tabn2<Cr>
nnoremap <silent> <M-3>  :tabn3<Cr>
nnoremap <silent> <M-4>  :tabn4<Cr>
nnoremap <silent> <M-5>  :tabn5<Cr>
nnoremap <silent> <M-6>  :tabn6<Cr>
nnoremap <silent> <M-7>  :tabn7<Cr>
nnoremap <silent> <M-8>  :tabn8<Cr>
nnoremap <silent> <M-9>  :tabn9<Cr>
nnoremap <silent> <M-0>  :tablast<Cr>
inoremap <silent> <M-1>  <C-o>:tabn1<Cr>
inoremap <silent> <M-2>  <C-o>:tabn2<Cr>
inoremap <silent> <M-3>  <C-o>:tabn3<Cr>
inoremap <silent> <M-4>  <C-o>:tabn4<Cr>
inoremap <silent> <M-5>  <C-o>:tabn5<Cr>
inoremap <silent> <M-6>  <C-o>:tabn6<Cr>
inoremap <silent> <M-7>  <C-o>:tabn7<Cr>
inoremap <silent> <M-8>  <C-o>:tabn8<Cr>
inoremap <silent> <M-9>  <C-o>:tabn9<Cr>
inoremap <silent> <M-0>  <C-o>:tablast<Cr>
" open window in tab
nnoremap <leader><Cr>  :e!<Cr>
" make tabline in terminal mode
nnoremap <silent><Tab>n :tabnext<CR>
nnoremap <silent><Tab>p :tabprevious<CR>
nnoremap <silent><Tab>N :tabm +1<CR>
nnoremap <silent><Tab>P :tabm -1<CR>
nnoremap <Tab>M         :tabm<Space>
" open in tab
nnoremap <leader>T <C-w>T
" set tab label
function! Vim_NeatBuffer(bufnr, fullname)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
        if l:name == ''
            return '[No Name]'
        else
            if a:fullname
                return fnamemodify(l:name, ':p')
            else
                return fnamemodify(l:name, ':t')
            endif
        endif
    else
        let l:buftype = getbufvar(a:bufnr, '&buftype')
        if l:buftype == 'quickfix'
            return '[Quickfix]'
        elseif l:name != ''
            if a:fullname
                return '-'.fnamemodify(l:name, ':p')
            else
                return '-'.fnamemodify(l:name, ':t')
            endif
        else
            return '[No Name]'
        endif
    endif
endfunc
" get a single tab label
function! Vim_NeatTabLabel(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufnr = l:buflist[l:winnr - 1]
    return Vim_NeatBuffer(l:bufnr, 0)
endfun
" get a single tab label in gui
function! Vim_NeatGuiTabLabel()
    let l:num = v:lnum
    let l:buflist = tabpagebuflist(l:num)
    let l:winnr = tabpagewinnr(l:num)
    let l:bufnr = l:buflist[l:winnr - 1]
    return Vim_NeatBuffer(l:bufnr, 0)
endfunc
" set tab label
if g:gui_running
    set guitablabel=%{Vim_NeatGuiTabLabel()}
else
    set tabline=%!Vim_NeatTabLine()
endif
" ------------------------
" choosewin
" ------------------------
PackAdd 'vim-choosewin'
nmap <M-w> <Plug>(choosewin)
" ------------------------
" windows resize
" ------------------------
function! s:check_winnr() abort
    if exists('*winnr')
        try
            let nr = winnr('h')
            return 1
        catch
            return 0
        endtry
    else
        return 0
    endif
endfunction
if s:check_winnr()
    " 判断方向上有没有窗口
    function! s:has_left() abort
        return winnr() != winnr('h')
    endfunction
    function! s:has_right() abort
        return winnr() != winnr('l')
    endfunction
    function! s:has_up() abort
        return winnr() != winnr('k')
    endfunction
    function! s:has_down() abort
        return winnr() != winnr('j')
    endfunction
    " 判断位置
    function! s:vertical_position() abort
        if !s:has_left() && !s:has_right()
            return 's'
        elseif s:has_left() && s:has_right()
            return 'm'
        elseif s:has_left()
            return 'l'
        else
            return 'h'
        endif
    endfunction
    function! s:horizontal_position() abort
        if !s:has_up() && !s:has_down()
            return 's'
        elseif s:has_up() && s:has_down()
            return 'm'
        elseif s:has_up()
            return 'j'
        else
            return 'k'
        endif
    endfunction
    " smartverticalresize
    let g:adjust_size = get(g:, 'adjust_size', 5)
    function! SmartVerticalResize(direction, ...) abort
        if a:0 != 1
            return
        endif
        let cur_position = s:vertical_position()
        let direction    = a:direction
        let change_side  = a:1
        if cur_position == 'h' || cur_position == 'm' && change_side == 'l'
            if direction == 'h'
                exec 'vertical resize -' . g:adjust_size
            else
                exec 'vertical resize +' . g:adjust_size
            endif
        elseif cur_position == 'l'
            if direction == 'h'
                exec 'vertical resize +' . g:adjust_size
            else
                exec 'vertical resize -' . g:adjust_size
            endif
        elseif cur_position == 'm'
            if direction == 'h'
                exec 'vertical ' . winnr('h') . 'resize -' . g:adjust_size
            else
                exec 'vertical ' . winnr('h') . 'resize +' . g:adjust_size
            endif
        endif
    endfunc
    nnoremap <silent> <Tab>h :call SmartVerticalResize('h', 'h')<Cr>
    nnoremap <silent> <Tab>l :call SmartVerticalResize('l', 'h')<Cr>
    nnoremap <silent> <Tab>j :call SmartVerticalResize('h', 'l')<Cr>
    nnoremap <silent> <Tab>k :call SmartVerticalResize('l', 'l')<Cr>
    " vertical change size
    function! SmartHorizontalResize(direction, ...) abort
        if a:0 != 1
            return
        endif
        let cur_pos     = s:horizontal_position()
        let direction   = a:direction
        let change_side = a:1
        if cur_pos == 'k' || cur_pos == 'm' && change_side == 'j'
            if direction == 'k'
                exec 'resize -' . g:adjust_size
            else
                exec 'resize +' . g:adjust_size
            endif
        elseif cur_pos == 'j'
            if direction == 'k'
                exec 'resize +' . g:adjust_size
            else
                exec 'resize -' . g:adjust_size
            endif
        elseif cur_pos == 'm'
            if direction == 'k'
                exec winnr('k') . 'resize -' . g:adjust_size
            else
                exec winnr('k') . 'resize +' . g:adjust_size
            endif
        endif
    endfunc
    nnoremap <silent> +     :call SmartHorizontalResize('k', 'k')<Cr>
    nnoremap <silent> _     :call SmartHorizontalResize('j', 'k')<Cr>
    nnoremap <silent> <M-+> :call SmartHorizontalResize('k', 'j')<Cr>
    nnoremap <silent> <M-_> :call SmartHorizontalResize('j', 'j')<Cr>
else
    nnoremap <Tab>j :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap <Tab>k :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap <Tab>h :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap <Tab>l :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap +      :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap _      :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap <M-+>  :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
    nnoremap <M-_>  :echo "winnr('hjkl') is not allowed in this vim, can not adjust panel size!"<Cr>
endif
" --------------------------
" complete engine
" ------------------------------
set completeopt-=preview
try
    set completeopt=menu,menuone,noselect,noinsert
catch
    try
        set completeopt=menuone,noselect,noinsert
        let g:complete_engine = 'mcm'
    catch
        let g:complete_engine = 'ncc'
    endtry
endtry
if CYGWIN() || Require('non')
    let g:complete_engine = 'non'
elseif get(g:, 'complete_engine', '') == 'ncc' || Require('ncc')
    let g:complete_engine = 'ncc'
elseif v:version >= 800 && Require('apc')
    let g:complete_engine = 'apc'
elseif Require('cmp')
    if has('nvim')
        let g:complete_engine = 'cmp'
    else
        let s:smart_engine_select = 1
    endif
elseif Require('coc')
    if get(g:, 'node_version', '') != '' && (has('nvim') || has('patch-8.2.0750'))
        let g:complete_engine = 'coc'
    else
        let s:smart_engine_select = 1
    endif
elseif Require('mcm')
    if &completeop =~ 'menuone' && (&completeopt =~ 'noselect' || &completeopt =~ 'noinsert')
        let g:complete_engine = 'mcm'
    else
        let s:smart_engine_select = 1
    endif
else
    let s:smart_engine_select = 1
endif
if get(s:, 'smart_engine_select', 0) > 0
    if get(g:, 'node_version', '') != '' && (has('nvim') || has('patch-8.2.0750'))
        let g:complete_engine = 'coc'
    elseif has('nvim')
        let g:complete_engine = 'cmp'
    elseif &completeopt =~ 'menuone' && (&completeopt =~ 'noselect' || &completeopt =~ 'noinsert')
        let g:complete_engine = 'mcm'
    else
        let g:complete_engine = 'ncc'
    endif
endif
if index(['coc', 'cmp'], get(g:, 'complete_engine', '')) >= 0
    let g:advanced_complete_engine = 1
    if exists('+completepopup') != 0
        set completeopt+=popup
        set completepopup=align:menu,border:off,highlight:WildMenu
    endif
else
    let g:advanced_complete_engine = 0
endif
" ------------------------------
" pack_tool
" ------------------------------
if g:pack_tool == 'plug'
    let $INSTALL_PATH = expand('~/.leovim.d/plug/' . g:complete_engine)
else
    let $INSTALL_PATH = expand('~/.leovim.d/' . g:complete_engine)
endif
if has('nvim')
    let $INSTALL_PATH .= ".nvim"
    luafile $LUA_PATH/utils.lua
else
    let $INSTALL_PATH .= ".vim"
endif
" --------------------------
" install plugins
" --------------------------
" pack begin
if g:pack_tool == 'jetpack'
    source ~/.leovim.conf/pack/jetpack.vim
    call jetpack#begin($INSTALL_PATH)
else
    source ~/.leovim.conf/pack/plug.vim
    call plug#begin($INSTALL_PATH)
endif
source $PACKSYNC_PATH/pack.vim
nnoremap <leader>ep :tabe $PACKSYNC_PATH/pack.vim<Cr>
nnoremap <leader>eP :tabe ~/.leovim.d/plus.vim<Cr>
if filereadable(expand("~/.leovim.d/plus.vim")) | source $HOME/.leovim.d/plus.vim | endif
" pack end, check installed
if g:pack_tool == 'jetpack'
    call jetpack#end()
else
    call plug#end()
endif
" set installed
if g:pack_tool == 'jetpack'
    for pack in jetpack#names()
        if jetpack#tap(pack)
            let g:leovim_installed[tolower(pack)] = 1
        endif
    endfor
else
    for [plug, value] in items(g:plugs)
        let dir = value['dir']
        if isdirectory(dir)
            let g:leovim_installed[tolower(plug)] = 1
        endif
    endfor
endif
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
            let l:confirmed = confirm('Do you really want to `quit`?', "&Yes\n&No", 2)
            if l:confirmed == 1
                q!
            end
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
" source start.vim
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
" set filetype unix and trim \r
" ------------------------
nnoremap <leader>ef :set ff=unix<Cr>:%s/\r//g<Cr>
" ------------------------
" open ide config files
" ------------------------
nnoremap <leader>ej :tabe $LEOVIM_PATH/jetbrains/idea.vim<Cr>
nnoremap <leader>en :tabe $LEOVIM_PATH/vscode/neovim.vim<Cr>
nnoremap <leader>ek :tabe $LEOVIM_PATH/vscode/keybindings.json<Cr>
source $SETTINGS_PATH/installed.vim
