" ------------------------------
" complete_engine
" ------------------------------
if g:complete_engine == 'coc'
    if g:node_version == 'advanced'
        PackAdd 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile', 'opt': 0}
    else
        PackAdd 'neoclide/coc.nvim', {'branch': 'release', 'opt': 0}
    endif
    PackAdd 'antoinemadec/coc-fzf'
    " basic
    let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-sql',
            \ 'coc-xml',
            \ 'coc-git',
            \ 'coc-sh',
            \ 'coc-powershell',
            \ 'coc-lists',
            \ 'coc-marketplace',
            \ 'coc-snippets',
            \ 'coc-explorer',
            \ 'coc-pairs',
            \ 'coc-yank',
            \ 'coc-highlight',
            \ 'coc-vimlsp',
            \ 'coc-pyright',
            \ 'coc-symbol-line',
            \ ]
    if Require('web')
        let g:coc_global_extensions += [
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-yaml',
            \ 'coc-phpls',
            \ 'coc-emmet',
            \ 'coc-tsserver',
            \ 'coc-angular',
            \ 'coc-vetur',
            \ ]
    endif
    if Require('c')
        let g:coc_global_extensions += ['coc-cmake']
        if executable('clangd')
            let g:coc_global_extensions += ['coc-clangd']
        endif
    endif
    if Require('R')
        let g:coc_global_extensions += ['coc-r-lsp']
    endif
    if Require('rust')
        let g:coc_global_extensions += ['coc-rust-analyzer']
    endif
    if Require('go')
        let g:coc_global_extensions += ['coc-go']
    endif
    if Require('latex')
        let g:coc_global_extensions += ['coc-vimtex']
    endif
    if Require('java') && executable('java')
        let g:coc_global_extensions += ['coc-java', 'coc-java-intellicode']
    endif
elseif g:complete_engine == 'cmp'
    PackAdd 'neovim/nvim-lspconfig'
                \| PackAdd 'williamboman/mason.nvim'
                \| PackAdd 'williamboman/mason-lspconfig.nvim'
                \| PackAdd 'junnplus/lsp-setup.nvim'
                \| PackAdd 'hrsh7th/nvim-cmp'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp'
                \| PackAdd 'hrsh7th/cmp-nvim-lua'
                \| PackAdd 'hrsh7th/cmp-path'
                \| PackAdd 'hrsh7th/cmp-buffer'
                \| PackAdd 'hrsh7th/cmp-omni'
                \| PackAdd 'hrsh7th/cmp-cmdline'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp-signature-help'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp-document-symbol'
                \| PackAdd 'onsails/lspkind-nvim'
endif
" ------------------------------
" complete_snippets
" ------------------------------
if g:complete_engine == 'cmp'
    let g:complete_snippets = 'luasnip'
elseif g:complete_engine == 'coc'
    if g:python_version > 3.6
        let g:complete_snippets = 'ultisnips-coc-snippets'
    else
        let g:complete_snippets = 'coc-snippets'
    endif
elseif g:complete_engine == 'apc'
    if g:python_version > 3.6
        let g:complete_snippets = 'ultinsips'
    else
        let g:complete_snippets = 'vsnip'
    endif
endif
if g:complete_snippets =~ 'ultisnips'
    PackAdd 'SirVer/ultisnips' | PackAdd 'honza/vim-snippets'
    PackAdd 'skywind3000/leaderf-snippet'
elseif g:complete_snippets =~ 'luasnip'
    PackAdd 'L3MON4D3/luasnip' | PackAdd 'saadparwaiz1/cmp_luasnip' | PackAdd 'benfowler/telescope-luasnip.nvim'
endif
if g:complete_snippets =~ 'vsnip' || g:complete_snippets =~ 'luasnip' || g:complete_snippets =~ 'coc'
    PackAdd 'rafamadriz/friendly-snippets'
endif
" ------------------------------
" check tool
" ------------------------------
if g:complete_engine == 'cmp'
    let g:check_tool = 'cmp'
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
