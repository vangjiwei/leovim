" --------------------------
" version require
" --------------------------
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
" --------------------------
" set dirs
" --------------------------
" set basic path
let $LEOVIM_PATH = expand('~/.leovim.conf')
" set config path
let $MAIN_PATH    = expand($LEOVIM_PATH . '/main')
let $CONFIG_PATH  = expand($MAIN_PATH . '/config')
let $REQUIRE_PATH = expand($MAIN_PATH . '/require')
let $LUA_PATH     = expand($CONFIG_PATH . '/lua')
" ------------------------
" set opt path which contains repos cloned.
" ------------------------
let $OPT_PATH = expand($LEOVIM_PATH . '/pack/repos/opt')
" ------------------------
" runtime packpath
" ------------------------
let $RUNTIME_PATH = expand($LEOVIM_PATH . '/runtime')
set rtp=$VIMRUNTIME,$RUNTIME_PATH
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
    " --------------------------
    " has popup or floating window
    " --------------------------
    if has("popupwin") || exists('*nvim_open_win')
        let g:has_popup_floating = get(g:, 'has_popup_floating', 1)
    else
        let g:has_popup_floating = 0
    endif
else
    let g:has_terminal = 0
    let g:has_popup_floating = 0
endif
" ----------------------------------------------------
" source commom.vim for vim/neovim/vscode
" ----------------------------------------------------
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
" pattern
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
" -----------------------------------
" set
" -----------------------------------
source $LEOVIM_PATH/set.vim
" ------------------------
" core map
" ------------------------
source $LEOVIM_PATH/map.vim
" ----------------------
" intergrated packs
" ---------------------
source $LEOVIM_PATH/intergrated.vim
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
    source $MAIN_PATH/common.vim
    if g:has_terminal > 0
        source $CONFIG_PATH/terminal.vim
    endif
endif
" ------------------------
" set leovim loaded
" ------------------------
let g:leovim_loaded = 1
