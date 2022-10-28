if g:complete_engine != 'coc' && has('nvim') && (UNIX() && get(g:, 'nvim_treesitter_install', 1) || WINDOWS() && get(g:, 'nvim_treesitter_install', 0))
    let g:nvim_treesitter_install = 1
    PackAdd 'kevinhwang91/nvim-treesitter'
                \| PackAdd 'm-demare/hlargs.nvim'
                \| PackAdd 'spywhere/detect-language.nvim'
    if g:complete_engine == 'cmp'
        PackAdd 'mfussenegger/nvim-treehopper'
    endif
    if g:complete_engine != 'coc' && get(g:, 'nvim_treesitter_textobjects', 0) > 0
        let g:nvim_treesitter_textobjects = 1
        PackAdd 'nvim-treesitter/nvim-treesitter-textobjects'
    else
        let g:nvim_treesitter_textobjects = 0
    endif
else
    let g:nvim_treesitter_install     = 0
    let g:nvim_treesitter_textobjects = 0
endif
if v:version >= 704 && g:advanced_complete_engine == 0 && get(g:, 'install_textobj_plus', 1)
    PackAdd 'kana/vim-textobj-function'
    PackAdd 'thinca/vim-textobj-function-perl', {'for': 'perl'}
    if g:python_version > 0
        PackAdd 'bps/vim-textobj-python', {'for': 'python'}
    endif
    " latex
    if Require('latex')
        PackAdd 'rbonvall/vim-textobj-latex', {'for': 'latex'}
    endif
    " web
    if Require('web')
        PackAdd 'kentaro/vim-textobj-function-php', {'for': 'php'}
        PackAdd 'thinca/vim-textobj-function-javascript', {'for': ['javascript', 'typescript']}
    endif
endif
if g:has_truecolor > 0
    " sainnhe's themes
    PackAdd 'sainnhe/edge'
    PackAdd 'sainnhe/sonokai'
    PackAdd 'sainnhe/everforest'
    PackAdd 'sainnhe/gruvbox-material'
    " other themes
    if Require('themes')
        PackAdd 'bluz71/vim-moonfly-colors'
        PackAdd 'bluz71/vim-nightfly-guicolors'
        if has('nvim')
            PackAdd 'EdenEast/nightfox.nvim'
        endif
    endif
endif
