" function to transform dotted string to float
" ------------------------------
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
" ------------------------
" mapleader
" ------------------------
let g:mapleader      = ' '
let g:maplocalleader = '\'
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
let $PACK_PATH = expand(get(g:, 'jetpack_forked', ''))
if exists('g:vscode')
    let g:pack_tool = ''
elseif exists(':packadd') && exists("##SourcePost") && (g:git_version >= 1.85 || executable('curl') || executable('wget')) && (isdirectory($PACK_PATH) || filereadable($PACK_PATH))
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
    if isdirectory($PACK_PATH)
        let g:pack_tool = 'jetpack_autoload'
        set rtp^=$PACK_PATH
    else
        let g:pack_tool = 'jetpack_sourcefile'
        source $PACK_PATH
    endif
    command! PackSync JetpackSync
else
    let g:pack_tool = 'plug'
    let g:plug_threads = get(g:, 'plug_threads', 8)
    source ~/.leovim.conf/pack/plug.vim
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
" pattern
let g:todo_patterns = "(TODO|FIXME|WARN|ERROR|BUG|HELP)"
let g:note_patterns = "(NOTE|XXX|HINT|STEP|ETC)"
let g:root_patterns = get(g:, 'root_patterns', [".root/", ".env/", ".git/", ".hg/", ".svn/", ".vim/", ".vscode/", '.idea/', ".ccls/", "compile_commands.json"])
" -----------------------------------
" set
" -----------------------------------
source $MAIN_PATH/set.vim
if WINDOWS()
    set termencoding=gbk
else
    let &termencoding=&enc
endif
" -----------------------------------
" wildmenu
" -----------------------------------
if has('patch-7.4.2201') || has('nvim')
    if has('nvim')
        setlocal signcolumn=yes:2
    else
        setlocal signcolumn=yes
    endif
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
" ------------------------
" core remap
" ------------------------
source $MAIN_PATH/map.vim
" some enhanced shortcuts
nmap gb 2g;a
nmap !  :!
xmap !  :<C-u>!<C-R>=GetVisualSelection()<Cr>
xmap .  :<C-u>normal .<Cr>
xmap /  y/<C-R>"
xmap ?  y?<C-R>"
" --------------------------
" filetype
" --------------------------
filetype plugin indent on
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Toggle modifiable for current buffer
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
" --------------------------
" StripTrailingWhiteSpace
" --------------------------
augroup TrailSpace
    autocmd FileType vim,c,cpp,java,go,php,javascript,typescript,python,rust,twig,xml,yml,perl,sql,r,conf,lua
        \ autocmd! BufWritePre <buffer> :call TripTrailingWhiteSpace()
augroup END
command! TripTrailingWhiteSpace call TripTrailingWhiteSpace()
nnoremap d<space> :TripTrailingWhiteSpace<Cr>
" ------------------------
" yank
" ------------------------
" osc52 yankpost
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
" ------------------------
" configs for vscode or neovim/vim
" ------------------------
if exists("g:vscode")
    source $LEOVIM_PATH/vscode/neovim.vim
else
    " ------------------------
    " vim-preview
    " ------------------------
    let g:preview#preview_position = "rightbottom"
    let g:preview#preview_size     = get(g:, 'asyncrun_open', 8)
    nnoremap <leader>ex Q
    nnoremap qq <C-w>z
    nnoremap <Tab>o cd:PreviewFile
    " ------------------------
    " source
    " ------------------------
    source $CONFIG_PATH/boostup.vim
    if g:has_terminal > 0
        source $CONFIG_PATH/terminal.vim
    endif
endif
" ----------------------
" intergrated packs
" ---------------------
source $MAIN_PATH/intergrated.vim
" ------------------------
" set leovim loaded
" ------------------------
let g:leovim_loaded = 1
