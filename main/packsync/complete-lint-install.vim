" ------------------------------
" complete_snippets
" ------------------------------
if g:complete_engine == 'cmp'
    if g:python_version > 3
        let g:complete_snippets = 'ultisnips'
    else
        let g:complete_snippets = 'luasnip'
    endif
elseif g:complete_engine == 'coc'
    if g:python_version > 3.6
        let g:complete_snippets = 'ultisnips-coc-snippets'
    else
        let g:complete_snippets = 'coc-snippets'
    endif
elseif g:complete_engine == 'mcm'
    if exists('##TextChangedP')
        if g:python_version > 3
            let g:complete_snippets = 'ultisnips'
        else
            let g:complete_snippets = 'vsnip'
        endif
    else
        let g:complete_snippets = ''
    endif
else
    let g:complete_snippets = ''
endif
if g:complete_snippets =~ 'ultisnips'
    PackAdd 'SirVer/ultisnips' | PackAdd 'honza/vim-snippets'
    if g:complete_engine == 'cmp'
        PackAdd 'quangnguyen30192/cmp-nvim-ultisnips' | PackAdd 'fhill2/telescope-ultisnips.nvim'
    else
        PackAdd 'skywind3000/leaderf-snippet'
    endif
elseif g:complete_snippets =~ 'luasnip'
    PackAdd 'L3MON4D3/luasnip' | PackAdd 'saadparwaiz1/cmp_luasnip' | PackAdd 'benfowler/telescope-luasnip.nvim'
elseif g:complete_snippets =~ 'vsnip'
    PackAdd 'hrsh7th/vim-vsnip'
endif
if g:complete_snippets =~ 'vsnip' || g:complete_snippets =~ 'luasnip' || g:complete_snippets =~ 'coc'
    PackAdd 'rafamadriz/friendly-snippets'
endif
" ------------------------------
" complete_engine
" ------------------------------
if g:complete_engine == 'mcm'
    PackAdd 'lifepillar/vim-mucomplete'
    if g:complete_snippets =~ 'vsnip'
        PackAdd 'hrsh7th/vim-vsnip-integ'
    endif
elseif g:complete_engine == 'coc'
    if g:node_version == 'advanced'
        PackAdd 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
    else
        PackAdd 'neoclide/coc.nvim', {'branch': 'release'}
    endif
    PackAdd 'leoatchina/coc-fzf', {'branch': 'empty_check'}
    let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-lua',
            \ 'coc-sql',
            \ 'coc-xml',
            \ 'coc-git',
            \ 'coc-sh',
            \ 'coc-powershell',
            \ 'coc-lists',
            \ 'coc-marketplace',
            \ 'coc-dictionary',
            \ 'coc-snippets',
            \ 'coc-explorer',
            \ 'coc-pairs',
            \ 'coc-yank',
            \ 'coc-highlight',
            \ 'coc-vimlsp',
            \ 'coc-pyright',
            \ ]
    if Require('c')
        if executable('ccls')
            let g:coc_global_extensions += ['coc-ccls']
        endif
        if executable('clangd')
            let g:coc_global_extensions += ['coc-clangd']
        endif
    endif
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
    if Require('java')
        let g:coc_global_extensions += ['coc-java', 'coc-java-intellicode']
    endif
elseif g:complete_engine == 'cmp'
    PackAdd 'williamboman/mason.nvim'
                \| PackAdd 'williamboman/mason-lspconfig.nvim'
                \| PackAdd 'neovim/nvim-lspconfig'
                \| PackAdd 'hrsh7th/nvim-cmp'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp'
                \| PackAdd 'hrsh7th/cmp-nvim-lua'
                \| PackAdd 'hrsh7th/cmp-path'
                \| PackAdd 'hrsh7th/cmp-buffer'
                \| PackAdd 'hrsh7th/cmp-omni'
                \| PackAdd 'hrsh7th/cmp-cmdline'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp-signature-help'
                \| PackAdd 'hrsh7th/cmp-nvim-lsp-document-symbol'
                \| PackAdd 'uga-rosa/cmp-dictionary'
                \| PackAdd 'onsails/lspkind-nvim'
endif
" ------------------------------
" lint tool
" ------------------------------
if g:complete_engine == 'coc'
    let g:lint_tool = 'coc'
elseif g:complete_engine == 'cmp'
    let g:lint_tool = 'cmp'
elseif g:python_version > 3.6 && v:version >= 800
    let g:lint_tool = 'ale'
    PackAdd 'dense-analysis/ale'
    PackAdd 'maximbaz/lightline-ale'
else
    let g:lint_tool = ''
endif
