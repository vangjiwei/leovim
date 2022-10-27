if CYGWIN()
    finish
endif
if g:advanced_complete_engine
    if (v:version >= 802 && (Require('debug') || Require('vimspector')) || has('nvim') && Require('vimspector')) && g:python_version > 3.6
        let vimspector_install = " ./install_gadget.py --update-gadget-config"
        PackAdd 'puremourning/vimspector', {'do': g:python_exe_path . vimspector_install}
    elseif has('nvim') && Require('debug')
        PackAdd 'mfussenegger/nvim-dap' | PackAdd 'rcarriga/nvim-dap-ui'
    endif
endif
if g:has_terminal > 0
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
endif
