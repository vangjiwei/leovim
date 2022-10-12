if UNIX() && has('nvim')
    PackAdd 'michaelb/sniprun', {'do': 'bash install.sh'}
endif
if has('nvim')
    PackAdd 'iron.nvim'
elseif !has('nvim')
    let g:sendtorepl_invoke_key = "cn"
    let g:repl_position         = 3
    let g:repl_cursor_down      = 1
    let g:repl_python_automerge = 1
    let g:repl_console_name     = "REPL"
    let g:repl_predefine_python = {
                \ 'pandas':     'import pandas as pd',
                \ 'numpy':      'import numpy as np',
                \ 'matplotlib': 'from matplotlib import pyplot as plt'
                \ }
    " WARN: PackAdd should be set after params
    PackAdd 'vim-repl'
endif
