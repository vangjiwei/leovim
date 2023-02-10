" ------------------------------
" complete_engine
" ------------------------------
if g:complete_engine == 'coc'
    if g:node_version == 'advanced'
        PackAdd 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
    else
        PackAdd 'neoclide/coc.nvim', {'branch': 'release'}
    endif
    PackAdd 'antoinemadec/coc-fzf'
elseif g:complete_engine == 'cmp'
    PackAdd 'neovim/nvim-lspconfig'
                \| PackAdd 'williamboman/mason.nvim'
                \| PackAdd 'williamboman/mason-lspconfig.nvim'
                \| PackAdd 'hrsh7th/nvim-cmp'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp'
                \| PackAdd 'hrsh7th/cmp-nvim-lua'
                \| PackAdd 'hrsh7th/cmp-path'
                \| PackAdd 'hrsh7th/cmp-buffer'
                \| PackAdd 'hrsh7th/cmp-cmdline'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp-signature-help'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp-document-symbol'
                \| PackAdd 'petertriho/cmp-git'
                \| PackAdd 'onsails/lspkind-nvim'
elseif g:complete_engine == 'mcm'
    PackAdd 'lifepillar/vim-mucomplete'
endif
" ------------------------------
" complete_snippets
" ------------------------------
if g:complete_engine == 'cmp'
    let g:complete_snippets = 'luasnip'
elseif g:complete_engine == 'coc'
    if g:python_version > 3.6
        let g:complete_snippets = 'ultisnips'
    else
        let g:complete_snippets = 'coc-snippets'
    endif
elseif g:complete_engine == 'mcm' && exists('##TextChangedP') && g:python_version > 3.6
    let g:complete_snippets = 'ultisnips'
else
    let g:complete_snippets = ''
endif
if g:complete_snippets == 'ultisnips'
    PackAdd 'SirVer/ultisnips' | PackAdd 'honza/vim-snippets'
    if g:has_popup_floating
        PackAdd 'skywind3000/leaderf-snippet'
    endif
elseif g:complete_snippets == 'luasnip'
    PackAdd 'L3MON4D3/luasnip' | PackAdd 'saadparwaiz1/cmp_luasnip' | PackAdd 'benfowler/telescope-luasnip.nvim'
endif
if g:complete_snippets == 'luasnip' || g:complete_snippets == 'coc-snippets'
    PackAdd 'rafamadriz/friendly-snippets'
endif
" ------------------------------
" check tool
" ------------------------------
if g:complete_engine == 'cmp'
    let g:check_tool = 'lsp'
    PackAdd 'josa42/nvim-lightline-lsp'
elseif g:complete_engine == 'coc'
    if g:python_version > 3.6 && Require('ale')
        let g:check_tool = 'ale'
    else
        let g:check_tool = 'coc'
    endif
elseif g:python_version > 3.6 && v:version >= 800 && Require('ale')
    let g:check_tool = 'ale'
else
    let g:check_tool = ''
endif
if g:check_tool == 'ale'
    PackAdd 'dense-analysis/ale'
    PackAdd 'maximbaz/lightline-ale'
endif
" ------------------------------
" cmdline complete
" ------------------------------
if has('nvim') && g:complete_engine != 'cmp' || v:version >= 801
    if has('nvim')
        function! UpdateRemotePlugins(...)
            " Needed to refresh runtime files
            let &rtp=&rtp
            UpdateRemotePlugins
        endfunction
        PackAdd 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
    else
        PackAdd 'gelguy/wilder.nvim'
    endif
endif
" ------------------------------
" debug tool
" ------------------------------
if g:advanced_complete_engine
    if (v:version >= 802 && Require('debug') || has('nvim') && Require('vimspector') && g:complete_engine != 'cmp') && g:python_version > 3.6
        let vimspector_install = " ./install_gadget.py --update-gadget-config"
        PackAdd 'puremourning/vimspector', {'do': g:python_exe_path . vimspector_install}
    elseif has('nvim') && Require('debug')
        PackAdd 'mfussenegger/nvim-dap' | PackAdd 'rcarriga/nvim-dap-ui'
    endif
endif
if g:has_terminal > 0
    if has('nvim')
        if LINUX()
            PackAdd 'michaelb/sniprun', {'do': 'bash install.sh'}
        endif
        PackAdd 'iron.nvim'
    else
        let g:sendtorepl_invoke_key = "cn"
        let g:repl_position         = 3
        let g:repl_cursor_down      = 1
        let g:repl_python_automerge = 1
        let g:repl_console_name     = "REPL"
        " python
        let g:repl_python_auto_send_unfinish_line = 0
        let g:repl_predefine_python = {
                    \ 'pandas':     'import pandas as pd',
                    \ 'numpy':      'import numpy as np',
                    \ 'matplotlib': 'from matplotlib import pyplot as plt'
                    \ }
        " WARN: PackAdd should be set after params
        PackAdd 'vim-repl'
    endif
endif
