" ------------------------
" get a single tab label
" ------------------------
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
" setup new tabline, just like %M%t in macvim
if g:gui_running
    set guitablabel=%{Vim_NeatGuiTabLabel()}
else
    set tabline=%!Vim_NeatTabLine()
endif
" ------------------------
" remap
" ------------------------
map ÏP <F1>
map ÏQ <F2>
map ÏR <F3>
map ÏS <F4>
map <F1>  <Nop>
map <F2>  <Nop>
map <F3>  <Nop>
map <F4>  <Nop>
map <F5>  <Nop>
map <F6>  <Nop>
map <F7>  <Nop>
map <F8>  <Nop>
map <F9>  <Nop>
map <F10> <Nop>
map <F11> <Nop>
map <F12> <Nop>
map <M-B> <Nop>
map <M-O> <Nop>
map <C-n> <Nop>
map <C-q> <Nop>
map <C-s> <Nop>
map <C-i> <Nop>
map <C-z> <Nop>
nmap <C-j> %
nmap <C-k> g%
xmap <C-j> %
xmap <C-k> g%
nnoremap S <Nop>
" ------------------------------
" node_version
" ------------------------------
if executable('node') && executable('npm')
    let s:node_version_raw = matchstr(system('node --version'), '\vv\zs\d{1,4}.\d{1,4}\ze')
    let s:node_version = StringToFloat(s:node_version_raw)
    if s:node_version >= 16  || s:node_version == 12.22 || s:node_version == 14.17
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
" ctags version
" ------------------------------
if WINDOWS()
    let g:ctags_type = 'Universal-json'
elseif executable('ctags') && has('patch-7.4.330')
    let g:ctags_type = system('ctags --version')[0:8]
    if g:ctags_type == 'Universal' && system('ctags --list-features | grep json') =~ 'json'
        let g:ctags_type = 'Universal-json'
    endif
else
    let g:ctags_type = ''
endif
" --------------------------
" set TERM && screen
" --------------------------
if WINDOWS()
    if isdirectory($HOME . "\\.leovim.d\\windows") && get(g:,'leovim_loaded',0) == 0
        let $PATH = $HOME  . "\\.leovim.d\\windows\\tools;" . $HOME  . "\\.leovim.d\\windows\\gtags\\bin;" . $HOME  . "\\.leovim.d\\windows\\cppcheck;" . $PATH
    endif
    set winaltkeys=no
    if g:gui_running
        set lines=999
        set columns=999
    endif
    if has('libcall') && !has('nvim') && g:gui_running
        let g:gvimfullscreendll = $HOME ."\\.leovim.d\\windows\\tools\\gvimfullscreen.dll"
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
" Mkey map
" --------------------------
imap <M-,> <C-o><M-,>
imap <M-.> <C-o><M-.>
imap <M-/> <C-o><M-/>
imap <M-?> <C-o><M-/>
imap <M-;> <C-o><M-;>
imap <M-:> <C-o><M-;>
inoremap <M-'> <C-r>"
cnoremap <M-'> <C-r>"
nnoremap <M-'> gP
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
if g:gui_running == 0 && executable('tmux') && !exists('g:vscode')
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
" Execute function
" --------------------------
function! Execute(cmd)
    let cmd = a:cmd
    redir => output
    silent execute cmd
    redir END
    return output
endfunction
" --------------------------
" python_support
" --------------------------
let g:python3_host_prog = get(g:, 'python3_host_prog', '')
let g:python_host_prog  = get(g:, 'python_host_prog', '')
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
Python3EOF
    endif
    return l:pyx_version
endfunction
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
nnoremap <C-l> <Tab>
" ------------------------
" panel jump
" ------------------------
nnoremap <Tab>H <C-w>H
nnoremap <Tab>J <C-w>J
nnoremap <Tab>K <C-w>K
nnoremap <Tab>L <C-w>L
nnoremap <Tab>v :vsplit<Space>
nnoremap <Tab>s :split<Space>
" ------------------------
" basic toggle and show
" ------------------------
nnoremap <M-k>n :set nonu! nonu?<Cr>
nnoremap <M-k>N :set norelativenumber \| set nonumber<Cr>
nnoremap <M-k>f :set nofoldenable! nofoldenable?<Cr>
nnoremap <M-k>w :set nowrap! nowrap?<Cr>
nnoremap <M-k>h :set nohlsearch? nohlsearch!<Cr>
nnoremap <M-k>i :set invrelativenumber<Cr>
nnoremap <M-k>s :colorscheme<Space>
nnoremap <M-k>t :setfiletype<Space>
nnoremap <M-k>c :command<Cr>
nnoremap <M-k>r :set relativenumber \| set number<Cr>
" registers
nnoremap <M-v> :registers<Cr>
" ------------------------
" list buffers and mark
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
nnoremap <leader><Tab> :tabe<space>
nnoremap <leader><Cr>  :e!<Cr>
" make tabline in terminal mode
nnoremap <silent><Tab>n :tabnext<CR>
nnoremap <silent><Tab>p :tabprevious<CR>
nnoremap <silent><Tab>N :tabm +1<CR>
nnoremap <silent><Tab>P :tabm -1<CR>
nnoremap <Tab>M         :tabm<Space>
" ------------------------
" open in tab
" ------------------------
nnoremap <Tab>t <C-w>T
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
" ------------------------------
" install plugins
" ------------------------------
source $PACKSYNC_PATH/complete-init.vim
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
" ------------------------------
" pack begin
" ------------------------------
if g:pack_tool == 'jetpack'
    call jetpack#begin($INSTALL_PATH)
else
    call plug#begin($INSTALL_PATH)
endif
source $PACKSYNC_PATH/pack.vim
nnoremap <leader>ep :tabe $PACKSYNC_PATH/pack.vim<Cr>
nnoremap <leader>eP :tabe ~/.leovim.d/plus.vim<Cr>
if filereadable(expand("~/.leovim.d/plus.vim")) | source $HOME/.leovim.d/plus.vim | endif
" ------------------------------
" pack end, and check installed
" ------------------------------
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
                \ 'n'  : 'NORMAL ',
                \ 'v'  : 'VISUAL ',
                \ 'V'  : 'V·Line ',
                \ "\<C-V>" : 'V·Block ',
                \ 'i'  : 'INSERT ',
                \ 'R'  : 'R ',
                \ 'Rv' : 'V·Replace ',
                \ 'c'  : 'Command ',
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
" ------------------------
" home end
" ------------------------
source $SETTINGS_PATH/finder-conf.vim
cmap <C-a> <Home>
cmap <C-e> <End>
imap <expr><C-b> pumvisible()? "\<C-b>":"\<C-o>I"
imap <expr><C-f> pumvisible()? "\<C-f>":"\<C-o>A"
imap <expr><C-a> pumvisible()? "\<C-a>":"\<C-o>I"
if g:complete_engine != 'mcm'
    imap <expr><C-e> pumvisible()? "\<C-e>":"\<C-o>A"
endif
" --------------------------
" complete_engine settings
" --------------------------
if InstalledCmp()
    source $SETTINGS_PATH/cmp.vim
elseif Installed('coc.nvim')
    source $SETTINGS_PATH/coc.vim
elseif Installed('vim-mucomplete')
    source $SETTINGS_PATH/mcm.vim
elseif g:complete_engine != 'non' && &completeopt =~ 'noselect'
    let g:complete_engine = 'apc'
else
    let g:complete_engine = 'non'
endif
if g:complete_engine == 'apc'
    source $SETTINGS_PATH/apc.vim
endif
if g:complete_engine != 'non'
    source $SETTINGS_PATH/snippets.vim
    source $SETTINGS_PATH/format.vim
    if g:advanced_complete_engine > 0
        source $SETTINGS_PATH/debug-conf.vim
    else
        source $SETTINGS_PATH/tab.vim
    endif
endif
" -----------------------------------
" menu
" -----------------------------------
set wildmenu
if has('nvim')
    set wildoptions+=pum
    if !InstalledCmp()
        cmap <expr> <down> pumvisible() ? '<right>' : '<down>'
        cmap <expr> <up>   pumvisible() ? '<left>'  : '<up>'
        cmap <expr> <C-j>  pumvisible() ? '<right>' : '<C-n>'
        cmap <expr> <C-k>  pumvisible() ? '<left>'  : '<C-p>'
    endif
else
    set wildmode=longest,list
    if has('patch-8.2.4500')
        set wildoptions+=pum,fuzzy
    endif
endif
" --------------------------
" settings
" --------------------------
source $SETTINGS_PATH/differ.vim
source $SETTINGS_PATH/lint-conf.vim
source $SETTINGS_PATH/search-replace.vim
source $SETTINGS_PATH/yank-paste.vim
source $SETTINGS_PATH/sidebar.vim
source $SETTINGS_PATH/run-conf.vim
source $SETTINGS_PATH/marks.vim
source $SETTINGS_PATH/query.vim
if g:complete_engine == 'cmp'
    if InstalledTelescope() && InstalledLsp() && InstalledCmp()
        luafile $LUA_PATH/lsp-search.lua
    endif
else
    source $SETTINGS_PATH/lsp-tag-search.vim
endif
source $SETTINGS_PATH/fold.vim
" ------------------------------
" schemes
" ------------------------------
source $SETTINGS_PATH/schemes.vim
" --------------------------
" whichkey
" --------------------------
if has('patch-7.4.330') && get(g:, 'which_key_type', 'vim') == ''
    echo "which key is disabled"
elseif has('nvim') && get(g:, 'which_key_type', 'vim') == 'nvim'
    PackAdd 'which-key.nvim'
    luafile $LUA_PATH/which-key-config.lua
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
    nnoremap <Space> :WhichKey       ' '<Cr>
    nnoremap <Tab>   :WhichKey       '<lt>Tab>'<Cr>
    nnoremap ,       :WhichKey       ','<Cr>
    nnoremap \       :WhichKey       '\'<Cr>
    nnoremap [       :WhichKey       '['<Cr>
    nnoremap ]       :WhichKey       ']'<Cr>
    xnoremap <Space> :WhichKeyVisual ' '<Cr>
    xnoremap <Tab>   :WhichKeyVisual '<lt>Tab>'<Cr>
    xnoremap ,       :WhichKeyVisual ','<Cr>
    xnoremap \       :WhichKeyVisual '\'<Cr>
    xnoremap [       :WhichKeyVisual '['<Cr>
    xnoremap ]       :WhichKeyVisual ']'<Cr>
    " gszc whichkey
    nnoremap g<Space> :WhichKey 'g'<Cr>
    nnoremap m<Space> :WhichKey 'm'<Cr>
    nnoremap s<Space> :WhichKey 's'<Cr>
    nnoremap S<Space> :WhichKey 'S'<Cr>
    nnoremap c<Space> :WhichKey 'c'<Cr>
    nnoremap z<Space> :WhichKey 'z'<Cr>
    nnoremap Z<Space> :WhichKey 'Z'<Cr>
    " C-f
    nnoremap <C-f> :WhichKey '<lt>C-f>'<Cr>
    xnoremap <C-f> :WhichKeyVisual '<lt>C-f>'<Cr>
    " git
    nnoremap <C-g> :WhichKey '<lt>C-g>'<Cr>
    " M- keys
    nnoremap <M-h> :WhichKey '<lt>M-h>'<Cr>
    nnoremap <M-j> :WhichKey '<lt>M-j>'<Cr>
    nnoremap <M-k> :WhichKey '<lt>M-k>'<Cr>
    nnoremap <M-l> :WhichKey '<lt>M-l>'<Cr>
    nnoremap <M-u> :WhichKey '<lt>M-u>'<Cr>
    nnoremap <M-c> :WhichKey       '<lt>M-c>'<Cr>
    xnoremap <M-c> :WhichKeyVisual '<lt>M-c>'<Cr>
    if index(['nvim-dap', 'termdebug', 'vimspector'], get(g:, 'debug_tool', '')) >= 0
        nnoremap <M-m> :WhichKey '<lt>M-m>'<Cr>
        nnoremap <M-d> :WhichKey '<lt>M-d>'<Cr>
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
    if get(g:, 'fuzzy_finder', '') != ''
        let params_dict['fuzzy_finder'] = g:fuzzy_finder
    endif
    if get(g:, 'complete_snippets', '') != ''
        let params_dict['complete_snippets'] = g:complete_snippets
    endif
    if get(g:, 'python_exe_path', '') != ''
        let params_dict['python_exe_path'] = g:python_exe_path
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
    if get(g:, 'lint_tool', '') != ''
        let params_dict['lint_tool'] = g:lint_tool
    endif
    if get(g:, 'input_method', '') != ''
        let params_dict['input_method'] = g:input_method
    endif
    if get(g:, 'pygments_import', 0)
        let params_dict['pygments_import'] = g:pygments_import
    endif
    if has('nvim') && exists('$TERM') && $TERM != ''
        let params_dict['$TERM'] = $TERM
    elseif !has('nvim') && exists('&term') && &term != ''
        let params_dict['term'] = &term
    endif
    if has('nvim')
        let params_dict['nvim_treesitter_context'] = get(g:, 'nvim_treesitter_context', 0)
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
" close and quit
" ------------------------
nnoremap <silent><leader>q :q!<Cr>
nnoremap <silent>,q        :qall!<Cr>
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
    endif
endfun
command! ConfirmQuit call ConfirmQuit()
nnoremap <silent><M-q> :ConfirmQuit<Cr>
" ------------------------
" source
" ------------------------
nnoremap <leader>e<Cr> :source $LEOVIM_PATH/start.vim<Cr>
" ------------------------
" open config file
" ------------------------
nnoremap <leader>es :tabe $LEOVIM_PATH/start.vim<Cr>
nnoremap <leader>el :tabe $HOME/.vimrc.local<Cr>
nnoremap <leader>eb :tabe $SETTINGS_PATH/basic.vim<Cr>
nnoremap <leader>ec :tabe $MAIN_PATH/common.vim<Cr>
if WINDOWS()
    nnoremap <leader>eu :tabe ~/.leovim.conf/main/lua
    nnoremap <leader>er :tabe ~/.leovim.conf/runtime
    nnoremap <leader>em :tabe ~/.leovim.conf/main
else
    nnoremap <leader>eu :tabe ~/.leovim.conf/main/lua/<Tab>
    nnoremap <leader>er :tabe ~/.leovim.conf/runtime/<Tab>
    nnoremap <leader>em :tabe ~/.leovim.conf/main/<Tab>
endif
" ------------------------
" open ide config files
" ------------------------
nnoremap <leader>ej :tabe $LEOVIM_PATH/jetbrains/idea.vim<Cr>
nnoremap <leader>en :tabe $LEOVIM_PATH/vscode/neovim.vim<Cr>
nnoremap <leader>ek :tabe $LEOVIM_PATH/vscode/keybindings.json<Cr>
" cp keybindings.json
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
" ------------------------
" set filetype unix and trim \r
" ------------------------
nnoremap <leader>ef :set ff=unix<Cr>:%s/\r//g<Cr>
source $SETTINGS_PATH/zfvime.vim
