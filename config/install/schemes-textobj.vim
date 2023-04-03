if has('nvim') && (UNIX() &&
            \ (get(g:, 'nvim_treesitter_install', 1) && g:complete_engine == 'cmp' ||
            \ get(g:, 'nvim_treesitter_install', 0))
            \ || WINDOWS() && get(g:, 'nvim_treesitter_install', 0))
    let g:nvim_treesitter_install = 1
    PackAdd 'nvim-treesitter/nvim-treesitter'
    PackAdd 'm-demare/hlargs.nvim'
    PackAdd 'mfussenegger/nvim-treehopper'
    PackAdd 'spywhere/detect-language.nvim'
else
    let g:nvim_treesitter_install = 0
endif
if v:version >= 704 && g:advanced_complete_engine == 0 && get(g:, 'vim_textobj_plus', 1)
    PackAdd 'kana/vim-textobj-function'
    PackAdd 'thinca/vim-textobj-function-perl', {'for': 'perl'}
    PackAdd 'kentaro/vim-textobj-function-php', {'for': 'php'}
    PackAdd 'thinca/vim-textobj-function-javascript', {'for': ['javascript', 'typescript']}
    PackAdd 'bps/vim-textobj-python', {'for': 'python'}
    PackAdd 'rbonvall/vim-textobj-latex', {'for': 'latex'}
endif
if g:has_truecolor > 0
    " sainnhe's themes
    PackAdd 'sainnhe/edge'
    PackAdd 'sainnhe/sonokai'
    PackAdd 'sainnhe/everforest'
    PackAdd 'sainnhe/gruvbox-material'
    if has('nvim')
        PackAdd 'EdenEast/nightfox.nvim'
    endif
endif
