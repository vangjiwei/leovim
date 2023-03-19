" ------------------------------
" ps1
" ------------------------------
if WINDOWS()
    PackAdd 'pprovost/vim-ps1', {'for': 'ps1'}
endif
" --------------------------
" C language
" --------------------------
if Require('c')
    PackAdd 'chxuan/cpp-mode', {'for': g:c_filetypes}
    PackAdd 'vim-scripts/a.vim', {'for': g:c_filetypes}
    if g:advanced_complete_engine
        PackAdd 'jackguo380/vim-lsp-cxx-highlight', {'for': g:c_filetypes}
    endif
    if executable('ccls')
        PackAdd 'm-pilia/vim-ccls', {'for': g:c_filetypes}
    endif
    if executable('cppman')
        PackAdd 'skywind3000/vim-cppman', {'for': g:c_filetypes}
    endif
endif
" --------------------------
" rust
" --------------------------
if Require('rust') && v:version >= 800
    PackAdd 'rust-lang/rust.vim', {'for': 'rust'}
    if has('nvim')
        PackAdd 'simrat39/rust-tools.nvim'
    endif
endif
" --------------------------
" perl
" --------------------------
if Require('perl') || Require('bioinfo')
    PackAdd 'vim-perl/vim-perl', {'for': 'perl'}
endif
" --------------------------
" bioinfo
" --------------------------
if Require('bioinfo')
    PackAdd 'bioSyntax/bioSyntax-vim', {'for': ['fq', 'fa', 'fasta', 'fastq', 'gtf', 'gtt', 'sam', 'bam']}
endif
" --------------------------
" R language
" --------------------------
if Require('R') && v:version >= 800
    PackAdd 'jalvesaq/Nvim-R', {'for': 'r'}
    " ------------------------------
    " nvim-r
    " ------------------------------
    let R_assign_map     = '<M-->'
    let R_rmdchunk       = '``'
    let R_objbr_place    = 'RIGHT'
    let R_objbr_opendf   = 0
    let R_objbr_openlist = 0
    " console size
    let R_rconsole_height = 14
    let R_objrb_w         = 50
    let R_rconsole_width  = 0
    let R_min_editor_width  = 18
    augroup Rresize
        au VimResized * let R_objrb_w = 50
        au VimResized * let R_rconsole_height = 14
        au VimResized * let R_rconsole_width = winwidth(0) - R_objrb_w
    augroup END
endif
" --------------------------
" julia
" --------------------------
if Require('julia') && v:version >= 800
    PackAdd 'JuliaEditorSupport/julia-vim', {'for': 'julia'}
endif
" ------------------------------
" writing
" ------------------------------
PackAdd 'dhruvasagar/vim-table-mode'
if Require('writing')
    " markdown
    PackAdd 'junegunn/vim-journal', {'for': 'markdown'}
    PackAdd 'ferrine/md-img-paste.vim', {'for': 'markdown'}
    " markdown preview
    if executable('node') && (has('nvim') || v:version >= 801) && executable('yarn')
        let g:markdown_tool = 'markdown-preview.nvim'
        PackAdd 'iamcco/markdown-preview.nvim', {'for': ['markdown'], 'do': 'cd app & yarn install'}
        PackAdd 'iamcco/mathjax-support-for-mkdp', {'for': ['markdown']}
        au FileType markdown nmap <M-R> <Plug>MarkdownPreview
        au FileType markdown nmap <M-B> <Plug>MarkdownPreviewStop
    elseif g:python_version > 0
        let g:markdown_tool = 'markdown-preview.vim'
        PackAdd 'iamcco/markdown-preview.vim', {'for': ['markdown']}
        PackAdd 'iamcco/mathjax-support-for-mkdp', {'for': ['markdown']}
        au FileType markdown nmap <M-R> <Plug>MarkdownPreview
        au FileType markdown nmap <M-B> <Plug>MarkdownPreviewStop
    endif
    if executable('mdr') && (has('nvim') || has('patch-8.1.1401'))
        PackAdd 'skanehira/preview-markdown.vim', {'for': ['markdown']}
        let g:preview_markdown_vertical = 1
        au FileType markdown nmap <M-F> :PreviewMarkdown<cr>
    endif
    " ------------------------------
    " latex
    " ------------------------------
    if executable(get(g:, "vimtex_view_method", ''))
        PackAdd 'lervag/vimtex', {'for': 'latex'}
        let g:tex_flavor = get(g:, 'tex_flaver', 'latex')
        let g:tex_conceal = get(g:, 'tex_conceal', 'abdmg')
        let g:vimtex_quickfix_mode = get(g:, 'vimtex_quickfix_mode', 0)
    endif
endif
