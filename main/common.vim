" ------------------------------
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
if exists(':packadd') && exists("##SourcePost") && Require('jetpack') && (g:git_version >= 1.85 || executable('curl') || executable('wget'))
    let g:pack_tool = 'jetpack'
    let g:jetpack_njobs = get(g:, 'jetpack_njobs', 8)
    if get(g:, 'jetpack_download_method', '') == ''
        if g:git_version >= 1.85
            let g:jetpack_download_method = get(g:, 'jetpack_download_method', 'git')
        else
            if executable('curl')
                let g:jetpack_download_method = get(g:, 'jetpack_download_method', 'curl')
            else
                let g:jetpack_download_method = get(g:, 'jetpack_download_method', 'wget')
            endif
        endif
    endif
    command! PackSync JetpackSync
else
    let g:pack_tool = 'plug'
    let g:plug_threads = get(g:, 'plug_threads', 8)
    command! PackSync PlugClean | PlugUpdate
endif
nnoremap <leader>u :PackSync<Cr>
" --------------------
" PackAdd local opt or github repo
" --------------------
let g:leovim_installed = {}
function! PackAdd(repo, ...)
    " delete last / or \
    let repo = substitute(a:repo, '[\/]\+$', '', '')
    if stridx(repo, '/') < 0
        let pack = repo
        if g:pack_tool == 'jetpack'
            execute "packadd " . pack
        else
            let dir = expand($OPT_PATH . "/" . pack)
            execute "set rtp+=" . dir
        endif
        let g:leovim_installed[tolower(pack)] = 1
    else
        if g:pack_tool == 'jetpack'
            if a:0 == 0
                call jetpack#add(repo)
            else
                call jetpack#add(repo, a:1)
            endif
        else
            if a:0 == 0
                call plug#(repo)
            else
                if has_key(a:1, "opt")
                    call remove(a:1, "opt")
                endif
                call plug#(repo, a:1)
            endif
        endif
        let pack = split(repo, '\/')[1]
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
function! InstalledFzf()
    return Installed(
                \ 'fzf',
                \ 'fzf.vim',
                \ 'fzf-preview.vim',
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
                \ 'cmp-path',
                \ 'cmp-buffer',
                \ 'cmp-omni',
                \ 'cmp-cmdline',
                \ 'cmp-nvim-lsp-signature-help',
                \ 'cmp-nvim-lsp-document-symbol',
                \ 'cmp-dictionary',
                \ 'lspkind-nvim',
                \ )
endfunction
" -----------------------------------
" filetypes definition
" -----------------------------------
let g:c_filetypes   = get(g:, 'c_filetypes', ["c", "cpp", "objc", "objcpp", "cuda"])
let g:web_filetypes = get(g:, 'web_filetypes', ['php', 'html', 'css', 'scss', 'javascript', 'typescript', 'vue'])
let g:highlight_filetypes = get(g:, 'highlight_filetypes', [
            \ 'c', 'cpp', 'c_sharp', 'cmake', 'cuda', 'java', 'rust', 'go',
            \ 'r', 'python', 'julia',
            \ 'json', 'toml',
            \ 'latex', 'dockerfile',
            \ 'bash', 'fish', 'perl', 'lua',
            \ 'css', 'scss', 'html', 'vue',
            \ 'javascript', 'typescript', 'php',
            \ ])
" pattern
let g:todo_patterns = "(TODO|FIXME|WARN|ERROR|BUG|HELP)"
let g:note_patterns = "(NOTE|XXX|HINT|STEP|ETC)"
let g:root_patterns = get(g:, 'root_patterns', [".root/", ".env/", ".git/", ".hg/", ".svn/", ".vim/", ".vscode/", '.idea/', ".ccls/", "compile_commands.json"])
" python_lint_ignore
let g:python_lint_ignore = "E101,E302,E251,E231,E226,E221,E127,E126,E123,E501,W291,F405,F403"
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
    set signcolumn=yes
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
nmap gI 2g;a
nmap !  :!
xmap !  :<C-u>!<C-R>=GetVisualSelection()<Cr>
xmap .  :<C-u>normal .<Cr>
xmap /  y/<C-R>"
xmap ?  y?<C-R>"
" --------------------------
" EscapedSearch
" --------------------------
xmap <silent> * :<C-u>call EscapedSearch()<CR>/<C-R>=@/<CR><CR>N
xmap <silent> # :<C-u>call EscapedSearch()<CR>?<C-R>=@/<CR><CR>N
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
if has('clipboard')
    " autocmd
    if exists("##ModeChanged")
        au ModeChanged *:s set clipboard=
        au ModeChanged s:* set clipboard=unnamedplus
    endif
    " yank
    nnoremap Y  "*y$:echo "Yank to the line ending to clipboard"<Cr>
    nnoremap yy "*yy:echo "Yank the line to clipboard"<Cr>
    xnoremap <C-c> "*y:echo "Yank selected to clipboard" \| let @*=trim(@*)<Cr>
else
    nnoremap Y y$
    xnoremap <C-c> y
endif
" ----------------------
" intergrated packs
" ---------------------
source $MAIN_PATH/intergrated.vim
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
    nnoremap <leader>Q Q
    nnoremap qq <C-w>z
    PackAdd 'vim-preview'
    " preview open
    nmap <silent> ,E cd:PreviewGoto edit<Cr><C-w>z
    nmap <silent> ,V cd:PreviewGoto vsplit<Cr><C-w>z
    nmap <silent> ,S cd:PreviewGoto split<Cr><C-w>z
    nmap <silent> ,T cd:PreviewGoto tabe<Cr>gT<C-w>zgt
    " preview file
    nmap ,<Cr> cd:PreviewFile<Space>
    " ------------------------
    " source
    " ------------------------
    source $SETTINGS_PATH/boostup.vim
    if g:has_terminal > 0
        source $SETTINGS_PATH/terminal.vim
    endif
endif
" ------------------------
" set leovim loaded
" ------------------------
let g:leovim_loaded = 1
