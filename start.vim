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
" set opt
let $OPT_PATH = expand($LEOVIM_PATH . '/pack/sync/opt')
" set config path
let $MAIN_PATH = expand($LEOVIM_PATH . '/main')
let $CONFIG_PATH = expand($MAIN_PATH . '/config')
let $REQUIRE_PATH = expand($MAIN_PATH . '/require')
" set lua
let $LUA_PATH = expand($CONFIG_PATH . '/lua')
" ------------------------
" runtime
" ------------------------
let $RUNTIME_PATH = expand($LEOVIM_PATH . '/runtime')
set rtp=$VIMRUNTIME,$RUNTIME_PATH
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
        if has('nvim')
            let g:has_popup_floating = 1
        else
            let g:has_popup_floating = get(g:, 'has_popup_floating', 1)
        endif
    else
        let g:has_popup_floating = 0
    endif
else
    let g:has_terminal = 0
    let g:has_popup_floating = 0
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
" ----------------------------------------------------
" source commom.vim for vim/neovim/vscode
" ----------------------------------------------------
source $MAIN_PATH/common.vim
