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
