" ====================================================================================================
" set Variables
" ====================================================================================================
if v:version < 704 && !has('nvim')
    echoe 'vim 7.4 is at least required when uing leovim.'
    finish
elseif !has('nvim-0.7.2') && has('nvim')
    echoe 'neovim 0.7.2 is at least required when using leovim.'
    finish
elseif !exists('*system')
    echoe 'function system() is required when using leovim.'
    finish
end
" ------------------------
" mapleader
" ------------------------
let g:mapleader      = ' '
let g:maplocalleader = '\'
" --------------------------
" set dirs
" --------------------------
" set basic path
let $LEOVIM_PATH = expand('~/.leovim.conf')
" packpath
let $PACK_PATH = expand($LEOVIM_PATH . '/pack')
" set config path
let $MAIN_PATH = expand($LEOVIM_PATH . '/main')
let $REQUIRE_PATH = expand($MAIN_PATH . '/require')
let $CONFIG_PATH = expand($MAIN_PATH . '/config')
let $LUA_PATH = expand($CONFIG_PATH . '/lua')
" set opt path which contains repos cloned.
let $OPT_PATH = expand($PACK_PATH . '/repos/opt')
set rtp=$VIMRUNTIME,$PACK_PATH
if exists(':packadd')
    set packpath=$LEOVIM_PATH
endif
" --------------------------
" init directories
" --------------------------
let dir_list = {
    \ 'backupdir': '.leovim.d/backup',
    \ 'viewdir':   '.leovim.d/views',
    \ 'directory': '.leovim.d/swap',
    \ }
if has('persistent_undo')
    let dir_list['undodir'] = '.leovim.d/undo'
endif
if has('nvim')
    set shadafile=$HOME/.leovim.d/shada.main
endif
for [settingname, dirname] in items(dir_list)
    let directory = $HOME . '/'. dirname
    if !isdirectory(directory)
        try
            silent! call mkdir(directory, "p")
        catch
            echo "Unable to create it. Try mkdir -p " . directory
            continue
        endtry
    endif
    exec "set " . settingname . "=" . directory
endfor
" --------------------------
" check gui_running
" --------------------------
if exists("g:vscode")
    let g:gui_running = 0
elseif has('gui_running')
    let g:gui_running = 1
elseif has('nvim')
    if has('gui_vimr')
        let g:gui_running = 1
    else
        if exists('g:GuiLoaded')
            if g:GuiLoaded != 0
                let g:gui_running = 1
            endif
        elseif exists('*nvim_list_uis') && len(nvim_list_uis()) > 0
            let uis = nvim_list_uis()[0]
            let g:gui_running = get(uis, 'ext_termcolors', 0)? 0 : 1
        elseif exists("+termguicolors") && (&termguicolors) != 0
            let g:gui_running = 1
        else
            let g:gui_running = 0
        endif
    endif
    if g:gui_running > 0
        call rpcnotify(1, 'Gui', 'Option', 'Tabline',   0)
        call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
        call rpcnotify(1, 'Gui', 'Option', 'Linespace', 2)
    endif
else
    let g:gui_running = 0
endif
if g:gui_running > 0
    set guioptions-=e
    set guioptions-=T
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions-=m
    set guioptions-=M
endif
" --------------------------
" System Type
" --------------------------
function! CYGWIN()
    return has('win32unix') && !has('macunix')
endfunction
function! WINDOWS()
    return has('win32') || has('win64')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! MACOS()
    return has('macunix')
endfunction
function! UNIX()
    return LINUX() || MACOS()
endfunction
function! MACVIM()
    return has('gui_running') && MACOS()
endfunction
if WINDOWS()
    if g:gui_running == 0 && !has('nvim')
        echoe "Using this config in windows vim without gui is not acceptable!"
        finish
    endif
    if v:version < 800
        echoe 'vim 8.0 or neovim 0.7.2 is at least required when uing leovim in windows.'
        finish
    endif
    let $NVIM_DATA_PATH = expand("~/AppData/Local/nvim-data")
else
    let $NVIM_DATA_PATH = expand("~/.local/share/nvim")
endif
if MACVIM() && !has('gui_vimr')
    set macmeta
endif
" --------------------------
" has_terminal
" --------------------------
if exists(':tnoremap') && !exists('g:vscode')
    if has('patch-8.1.1')
        set termwinkey=<C-_>
        let g:has_terminal=2
    else
        let g:has_terminal=1
    endif
    " has popup or floating window
    if has("popupwin") || exists('*nvim_open_win')
        let g:has_popup_floating = get(g:, 'has_popup_floating', 1)
    else
        let g:has_popup_floating = 0
    endif
else
    let g:has_terminal = 0
    let g:has_popup_floating = 0
endif
" ------------------------
" EnhancedSearch
" ------------------------
function! EnhancedSearch() range
    let l:saved_reg = @"
    execute 'normal! vgvy'
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
nmap <silent> * :<C-u>call EnhancedSearch()<CR>/<C-R>=@/<CR><CR>N
nmap <silent> # :<C-u>call EnhancedSearch()<CR>?<C-R>=@/<CR><CR>N
inoremap <leader> <leader><c-g>u
" -----------------------------------
" delete tmp/swp files
" -----------------------------------
if WINDOWS()
    nnoremap <leader>X :!powershell <C-r>=expand("~/_leovim.clean.cmd")<Cr><Cr> \| e %<Cr>
else
    nnoremap <leader>X :!bash <C-r>=expand("~/.leovim.clean")<Cr><Cr><C-l>
endif
" ------------------------------
" git version
" ------------------------------
" important function to convert string to float
function! StringToFloat(str)
    let str = a:str
    try
        let lst   = split(str, "\\.")
        let main  = lst[0]
        let other = join(lst[1:], '')
        return str2float(main . "\." . other)
    catch
        return str2float(str)
    endtry
endfunction
if executable('git')
    let s:git_version_raw = matchstr(system('git --version'), '\v\zs\d{1,4}.\d{1,4}.\d{1,4}\ze')
    let g:git_version = StringToFloat(s:git_version_raw)
else
    let g:git_version = 0
endif
" --------------------------
" XXX: read .vimrc.local file to plugs settings
" --------------------------
let g:require_group = []
if filereadable(expand("~/.vimrc.local")) | source $HOME/.vimrc.local | endif
function! Require(plug)
    return count(g:require_group, a:plug)
endfunction
function! AddRequire(plug)
    if !Require(a:plug)
        let g:require_group += [a:plug]
    endif
endfunction
" -----------------------------------
" set pack_tool
" -----------------------------------
if exists('g:vscode')
    let g:pack_tool = ''
elseif exists(':packadd') && (g:git_version >= 1.85 || executable('curl') || executable('wget')) && filereadable(expand(get(g:, 'jetpack_forked', '')))
    let g:jetpack_njobs = get(g:, 'jetpack_njobs', 8)
    if get(g:, 'jetpack_download_method', '') == ''
        if executable('git')
            let g:jetpack_download_method = get(g:, 'jetpack_download_method', 'git')
        elseif executable('curl')
            let g:jetpack_download_method = get(g:, 'jetpack_download_method', 'curl')
        else
            let g:jetpack_download_method = get(g:, 'jetpack_download_method', 'wget')
        endif
    endif
    let g:jetpack_ignore_patterns =
                \ [
                \   '[\/]doc[\/]tags*',
                \   '[\/]test[\/]*',
                \   '[\/].git[\/]*',
                \   '[\/].github[\/]*',
                \   '[\/].gitignore',
                \   '[\/][.ABCDEFGHIJKLMNOPQRSTUVWXYZ]*',
                \ ]
    " load jetpack forked from tani
    let g:pack_tool = 'jetpack_forked'
    execute "source " . g:jetpack_forked
    command! PackSync JetpackSync
else
    let g:pack_tool = 'plug'
    let g:plug_threads = get(g:, 'plug_threads', 8)
    source ~/.leovim.conf/pack/repos/plug.vim
    command! PackSync PlugClean | PlugUpdate
endif
noremap <silent><leader>u :PackSync<Cr>
" ---------------------------------------
" PackAdd local opt packs or github repos
" ---------------------------------------
let g:leovim_installed = {}
function! PackAdd(repo, ...)
    " delete last / or \
    let repo = substitute(a:repo, '[\/]\+$', '', '')
    " if not / included, local plugin will be loaded
    if stridx(repo, '/') < 0
        let pack = repo
    else
        let pack = split(repo, '\/')[1]
    endif
    if has_key(g:leovim_installed, pack)
        return
    elseif stridx(repo, '/') < 0
        if exists(':packadd')
            execute "packadd " . pack
        else
            let dir = expand($OPT_PATH . "/" . pack)
            execute "set rtp+=" . dir
        endif
        let g:leovim_installed[tolower(pack)] = 1
    else
        if g:pack_tool =~ 'jetpack'
            if a:0 == 0
                call jetpack#add(repo)
            else
                call jetpack#add(repo, a:1)
            endif
        elseif g:pack_tool == 'plug'
            if a:0 == 0
                call plug#(repo)
            else
                call plug#(repo, a:1)
            endif
        endif
        let g:leovim_installed[tolower(pack)] = 0
    endif
endfunction
command! -nargs=+ -bar PackAdd call PackAdd(<args>)
" -----------------------------------
" Installed & Planned
" -----------------------------------
function! Installed(...)
    for l:pack in a:000
        let pack = tolower(l:pack)
        if get(g:leovim_installed, pack, 0) == 0
            return 0
        endif
    endfor
    return 1
endfunction
function! Planned(...)
    for l:pack in a:000
        let pack = tolower(l:pack)
        if !has_key(g:leovim_installed, pack)
            return 0
        endif
    endfor
    return 1
endfunction
function! InstalledFZF()
    return Installed(
                \ 'fzf',
                \ 'fzf.vim',
                \ )
endfunction
function! InstalledTelescope()
    return Installed(
                \ 'nui.nvim',
                \ 'plenary.nvim',
                \ 'telescope.nvim',
                \ )
endfunction
function! InstalledLsp()
    return Installed(
                \ 'nvim-lspconfig',
                \ 'mason.nvim',
                \ 'mason-lspconfig.nvim',
                \ 'lspsaga.nvim',
                \ )
endfunction
function! InstalledCmp()
    return Installed(
                \ 'nvim-cmp',
                \ 'cmp-nvim-lsp',
                \ 'cmp-nvim-lua',
                \ 'cmp-path',
                \ 'cmp-buffer',
                \ 'cmp-cmdline',
                \ 'cmp-nvim-lsp-signature-help',
                \ 'cmp-nvim-lsp-document-symbol',
                \ 'lspkind-nvim',
                \ 'luasnip',
                \ )
endfunction
" -----------------------------------
" filetypes definition
" -----------------------------------
let g:c_filetypes   = get(g:, 'c_filetypes', ["c", "cpp", "objc", "objcpp", "cuda"])
let g:web_filetypes = get(g:, 'web_filetypes', ['php', 'html', 'css', 'scss', 'javascript', 'typescript', 'vue'])
let g:highlight_filetypes = get(g:, 'highlight_filetypes', [
            \ 'markdown', 'vim', 'lua',
            \ 'r', 'python','bash',
            \ 'c', 'cpp', 'cmake', 'java', 'rust', 'go',
            \ ])
" -----------------------------------
" pattern
" -----------------------------------
let g:todo_patterns = "(TODO|FIXME|WARN|ERROR|BUG|HELP)"
let g:note_patterns = "(NOTE|XXX|HINT|STEP|ETC)"
let g:root_patterns = get(g:, 'root_patterns', [".root/", ".env/", ".git/", ".hg/", ".svn/", ".vim/", ".vscode/", '.idea/', ".ccls/", "compile_commands.json"])
" -----------------------------------
" Toggle modifiable for current buffer
" -----------------------------------
function! s:toggle_modify() abort
    if &modifiable
        setl nomodifiable
        echo 'Current buffer is now non-modifiable'
    else
        setl modifiable
        echo 'Current buffer is now modifiable'
    endif
endfunction
command! ToggleModity call s:toggle_modify()
nnoremap <silent> <space>e<space> :ToggleModity<Cr>
" ========================================================================================================
" set
" ========================================================================================================
set nocompatible
set noai
set nosi
set noimdisable
set nojoinspaces
set nospell
set noeb
set nocursorcolumn
set nowrap
set nofoldenable
set nolist
set nobackup
set nowritebackup
set swapfile
set splitright
set splitbelow
set cursorline
set incsearch
set ruler
set hlsearch
set showmode
set vb
set autochdir
set smartcase
set ignorecase
set showmatch
set wildchar=<Tab>
set backspace=indent,eol,start
set linespace=0
set enc=utf8
set fencs=utf-8,utf-16,ucs-bom,gbk,gb18030,big5,latin1
set winminheight=0
set scrolljump=5
set scrolloff=3
set mouse=a
" tab
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set textwidth=160
" switchbuf
set buftype=
set switchbuf=useopen,usetab,newtab
" number mode
set number
set relativenumber
try
    set nrformats+=unsigned
catch
    " pass
endtry
" -----------------------------------
" termencoding
" -----------------------------------
if WINDOWS()
    set termencoding=gbk
else
    let &termencoding=&enc
endif
" -----------------------------------
" wildmenu
" -----------------------------------
if has('patch-7.4.2201') || has('nvim')
    setlocal signcolumn=yes
endif
if has('wildignore')
    set wildignore+=*\\tmp\\*,*/tmp/*,*.swp,*.exe,*.dll,*.so,*.zip,*.tar*,*.7z,*.rar,*.gz,*.pyd,*.pyc,*.ipynb
    set wildignore+=.ccls-cache/*,.idea/*,.vscode/*,__pycache__/*,.git/*,.svn/*,.hg/*
endif
" ------------------------
" shortmess
" ------------------------
try
    set shortmess+=a
catch
    " +a get use short messages
endtry
try
    set shortmess+=c
catch
    " +c get rid of annoying completion notifications
endtry
" --------------------------
" filetype
" --------------------------
filetype plugin indent on
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" =====================================================================================================
" map
" =====================================================================================================
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
nmap S    <Nop>
nmap <C-j> %
nmap <C-k> g%
xmap <C-j> %
xmap <C-k> g%
nmap <BS> <C-h>
" core remap
xmap     >>       >gv
xmap     <<       <gv
nnoremap <silent> gj j
nnoremap <silent> gk k
nnoremap <silent> j gj
nnoremap <silent> k gk
" home end
nnoremap H ^
xnoremap H ^
onoremap H ^
nnoremap L g_
xnoremap L g_
onoremap L g_
" z remap
nnoremap zs <Nop>
nnoremap zS <Nop>
nnoremap zw <Nop>
nnoremap zW <Nop>
nnoremap zg <Nop>
nnoremap zG <Nop>
nnoremap zl zL
nnoremap zh zH
nnoremap zr zR
nnoremap z= zT
nnoremap z- zB
nnoremap ZT zt
nnoremap zt z<CR>
" --------------------------
" basic tetxobj
" --------------------------
nnoremap <leader>vp viwp
nnoremap <leader>v' vi'
nnoremap <leader>v" vi"
nnoremap <leader>v( va)
nnoremap <leader>v) vi)
nnoremap <leader>v[ va]
nnoremap <leader>v] vi]
nnoremap <leader>v{ va}
nnoremap <leader>v} vi}
nnoremap <leader>v< va>
nnoremap <leader>v> vi>
nnoremap <leader>c' ci'
nnoremap <leader>c" ci"
nnoremap <leader>c( ca)
nnoremap <leader>c) ci)
nnoremap <leader>c[ ca]
nnoremap <leader>c] ci]
nnoremap <leader>c{ ca}
nnoremap <leader>c} ci}
nnoremap <leader>c< ca>
nnoremap <leader>c> ci>
nnoremap <leader>d' di'
nnoremap <leader>d" di"
nnoremap <leader>d( da)
nnoremap <leader>d) di)
nnoremap <leader>d[ da]
nnoremap <leader>d] di]
nnoremap <leader>d{ da}
nnoremap <leader>d} di}
nnoremap <leader>d< da>
nnoremap <leader>d> di>
nnoremap <leader>y' yi'
nnoremap <leader>y" yi"
nnoremap <leader>y( ya)
nnoremap <leader>y) yi)
nnoremap <leader>y[ ya]
nnoremap <leader>y] yi]
nnoremap <leader>y{ ya}
nnoremap <leader>y} yi}
nnoremap <leader>y< ya>
nnoremap <leader>y> yi>
" ------------------------
" some enhanced shortcuts
" ------------------------
nmap gb 2g;a
nmap !  :!
xmap !  :<C-u>!<C-R>=GetVisualSelection()<Cr>
xmap .  :<C-u>normal .<Cr>
xmap /  y/<C-R>"
xmap ?  y?<C-R>"
" ------------------------
" yank
" ------------------------
if exists("##TextYankPost") && UNIX() && exists('*trim')
    function! s:raw_echo(str)
        if filewritable('/dev/fd/2')
            call writefile([a:str], '/dev/fd/2', 'b')
        else
            exec("silent! !echo " . shellescape(a:str))
            redraw!
        endif
    endfunction
    function! s:copy() abort
        let c = join(v:event.regcontents,"\n")
        if len(trim(c)) == 0
            return
        endif
        let c64 = system("base64", c)
        if $TMUX == ''
            let s = "\e]52;c;" . trim(c64) . "\x07"
        else
            let s = "\ePtmux;\e\e]52;c;" . trim(c64) . "\x07\e\\"
        endif
        call s:raw_echo(s)
    endfunction
    autocmd TextYankPost * call s:copy()
endif
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
xnoremap zp "_c<ESC>p"
xnoremap zP "_c<ESC>P"
" Yank a line without leading whitespaces and line break
nnoremap <leader>yu mp_yg_`p
" Copy a line without leading whitespaces and line break to clipboard
nnoremap <leader>yw mp_"+yg_`P
" Copy file path
nnoremap <leader>yp :let @*=expand("%:p")<cr>:echo '-= File path copied=-'<Cr>
" Copy file name
nnoremap <leader>yf :let @*=expand("%:t")<cr>:echo '-= File name copied=-'<Cr>
" Copy bookmark position reference
nnoremap <leader>yb :let @*=expand("%:p").':'.line(".").':'.col(".")<cr>:echo '-= Cursor bookmark copied=-'<cr>'
" --------------------------
" StripTrailingWhiteSpace
" --------------------------
augroup TrailSpace
    autocmd FileType vim,c,cpp,java,go,php,javascript,typescript,python,rust,twig,xml,yml,perl,sql,r,conf,lua
        \ autocmd! BufWritePre <buffer> :call TripTrailingWhiteSpace()
augroup END
command! TripTrailingWhiteSpace call TripTrailingWhiteSpace()
nnoremap d<space> :TripTrailingWhiteSpace<Cr>
" ====================================================================================================
" intergrated packs
" ====================================================================================================
PackAdd 'vim-eunuch'
" ------------------------
" Find merge conflict markers
" ------------------------
let g:conflict_marker_enable_mappings = 0
PackAdd 'conflict-marker.vim'
nnoremap <leader>c/ /\v^[<\|=>]{7}( .*\|$)<CR>
nnoremap <leader>c? ?\v^[<\|=>]{7}( .*\|$)<CR>
nnoremap <leader>ct :ConflictMarkerThemselves<Cr>
nnoremap <leader>co :ConflictMarkerOurselves<Cr>
nnoremap <leader>cn :ConflictMarkerNone<Cr>
nnoremap <leader>cb :ConflictMarkerBoth<Cr>
nnoremap <leader>c; :ConflictMarkerNextHunk<Cr>
nnoremap <leader>c, :ConflictMarkerPrevHunk<Cr>
" --------------------------
" easyalign
" --------------------------
let g:easy_align_delimiters = {}
let g:easy_align_delimiters['#'] = {'pattern': '#', 'ignore_groups': ['String']}
let g:easy_align_delimiters['*'] = {'pattern': '*', 'ignore_groups': ['String']}
PackAdd 'vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap g, ga*,
xmap g= ga*=
xmap g: ga*:
xmap g<Space> ga*<Space>
" --------------------------
" matchup
" --------------------------
if g:has_popup_floating
    let g:matchup_matchparen_offscreen = {'methed': 'popup'}
else
    let g:matchup_matchparen_offscreen = {'methed': 'status_manual'}
endif
PackAdd 'vim-matchup'
xnoremap <sid>(std-I) I
xnoremap <sid>(std-A) A
xmap <expr> I mode()=='<c-v>'?'<sid>(std-I)':(v:count?'':'1').'i'
xmap <expr> A mode()=='<c-v>'?'<sid>(std-A)':(v:count?'':'1').'a'
nnoremap <silent><M-M> :MatchupWhereAmI??<Cr>
xnoremap <silent><M-M> <ESC>:MatchupWhereAmI??<Cr>
function! s:matchup_convenience_maps()
    for l:v in ['', 'v', 'V', '<c-v>']
        execute 'omap <expr>' l:v.'I%' "(v:count?'':'1').'".l:v."i%'"
        execute 'omap <expr>' l:v.'A%' "(v:count?'':'1').'".l:v."a%'"
    endfor
endfunction
call s:matchup_convenience_maps()
" ------------------------
" easymotion
" ------------------------
let g:EasyMotion_keys = '123456789asdghklqwertyuiopzxcvbnmfj,;'
if exists('g:vscode')
    PackAdd 'vim-easymotion-vscode'
else
    PackAdd 'vim-easymotion'
endif
PackAdd 'vim-easymotion-chs'
source $CONFIG_PATH/easymotion.vim
" ------------------------
" clever-f
" ------------------------
let g:clever_f_smart_case = 1
let g:clever_f_repeat_last_char_inputs = ['<Tab>']
PackAdd 'clever-f.vim'
nmap ; <Plug>(clever-f-repeat-forward)
xmap ; <Plug>(clever-f-repeat-forward)
nmap , <Plug>(clever-f-repeat-back)
xmap , <Plug>(clever-f-repeat-back)
" ------------------------
" surround
" ------------------------
nmap SL vg_S
nmap SH v^S
nmap SJ vt<Space>S
nmap SK vT<Space>S
nmap SS T<Space>vt<Space>S
" --------------------------
" textobj
" --------------------------
PackAdd 'vim-textobj-user'
PackAdd 'vim-textobj-syntax'
PackAdd 'vim-textobj-uri'
PackAdd 'vim-textobj-line'
nmap <leader>vf vif
nmap <leader>vF vaf
nmap <leader>vu viu
nmap <leader>vU vau
nmap <leader>vl vil
nmap <leader>vL val
nmap <leader>vt vi%
nmap <leader>vT va%
nmap <leader>va via
nmap <leader>vA vaa
nmap <leader>vi vii
nmap <leader>vI vai
" ------------------------
" goto first/last indent
" ------------------------
nmap si viio<C-[>^
nmap sg vii<C-[>^
" --------------------------
" sandwich
" --------------------------
PackAdd 'vim-sandwich'
xmap is <Plug>(textobj-sandwich-auto-i)
xmap as <Plug>(textobj-sandwich-auto-a)
omap is <Plug>(textobj-sandwich-auto-i)
omap as <Plug>(textobj-sandwich-auto-a)
xmap iq <Plug>(textobj-sandwich-query-i)
xmap aq <Plug>(textobj-sandwich-query-a)
omap iq <Plug>(textobj-sandwich-query-i)
omap aq <Plug>(textobj-sandwich-query-a)
nmap <leader>vs vis
nmap <leader>vS vas
nmap <leader>vq viq
nmap <leader>vQ vaq
" ------------------------
" find block
" ------------------------
let s:block_str = '^# In\[\|^# %%'
function! BlockA()
    let beginline = search(s:block_str, 'ebW')
    if beginline == 0
        normal! gg
    endif
    let head_pos = getpos('.')
    let endline  = search(s:block_str, 'eW')
    if endline == 0
        normal! G
    endif
    let tail_pos = getpos('.')
    return ['V', head_pos, tail_pos]
endfunction
function! BlockI()
    let beginline = search(s:block_str, 'ebW')
    if beginline == 0
        normal! gg
        let beginline = 1
    else
        normal! j
    endif
    let head_pos = getpos('.')
    let endline = search(s:block_str, 'eW')
    if endline == 0
        normal! G
    elseif endline > beginline
        normal! k
    endif
    let tail_pos = getpos('.')
    return ['V', head_pos, tail_pos]
endfunction
" vib vab to select a block
call textobj#user#plugin('block', {
            \   'block': {
            \     'select-a-function': 'BlockA',
            \     'select-a': 'aB',
            \     'select-i-function': 'BlockI',
            \     'select-i': 'iB',
            \     'region-type': 'V'
            \   },
            \ })
nmap <leader>vb viB
nmap <leader>vB vaB
" =========================================================================
" source
" =========================================================================
if exists("g:vscode")
    source $LEOVIM_PATH/vscode/neovim.vim
else
    " vim-preview
    let g:preview#preview_position = "rightbottom"
    let g:preview#preview_size = get(g:, 'asyncrun_open', 8)
    nnoremap <leader>ex Q
    nnoremap qq <C-w>z
    nnoremap <Tab>o cd:PreviewFile
    " source
    source $MAIN_PATH/common.vim
    if g:has_terminal > 0
        source $CONFIG_PATH/terminal.vim
    endif
endif
" ------------------------
" set leovim loaded
" ------------------------
let g:leovim_loaded = 1
