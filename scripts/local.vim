let g:require_group = get(g:, 'preset_group', [])
let g:require_group += ['themes']

" https://github.com/nvim-telescope/telescope-fzf-native.nvim
" cmd to compile telescope_fzf
" let g:telescope_fzf_make_cmd = ''

let g:highlight_filetypes = [
            \ 'c_sharp', 'cpp', 'c', 'cmake',
            \ 'java', 'rust', 'go',
            \ 'r', 'python', 'julia',
            \ 'javascript', 'typescript',
            \ 'css', 'scss', 'json', 'toml',
            \ 'lua', 'dockerfile', 'latex',
            \ 'vim',
            \ ]

if WINDOWS()
    " let g:python3_host_prog='C:\\Python37\\python.exe'
    " let &pythonthreedll='C:\\Python37\\python37.dll'
    " let &pythonthreehome='C:\\Python37'
elseif UNIX()
    " let g:python3_host_prog=$HOME.'/miniconda3/bin/python3'
endif

" fonts
if g:gui_running && !CYGWIN()
    if WINDOWS()
        " let &guifont="Consolas:h10"
        " let &guifont="Cascadia Code:h12"
    elseif LINUX()
        " set guifont=Consolas\ 11
        " set guifont=Cascadia\ Code\ 11
    endif
endif

" https://ftp.gnu.org/pub/gnu/global/
" wget latest gtags version && ./configure --prefix ~/.local && make && make install
if executable('gtags') && executable('gtags-cscope')
    " let g:Lf_Gtagsconf=expand($HOME."/.local/share/gtags/gtags.conf")
endif

" let g:vimtex_view_method = 'zathura'

" let g:header_field_author       = 'your name'
" let g:header_field_author_email = 'your_name@email.com'
