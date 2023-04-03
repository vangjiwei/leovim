" ----------------------------
" Disable file with size > 1MB
" ----------------------------
autocmd BufAdd * if getfsize(expand('<afile>')) > 1024*1024 |
            \ let b:coc_enabled=0 |
            \ endif
" ----------------------------
" set $PATH
" ----------------------------
let g:coc_config_home = expand("$CONFIG_PATH")
if WINDOWS()
    let g:coc_data_home = $NVIM_DATA_PATH . "\\coc"
else
    let g:coc_data_home = $NVIM_DATA_PATH . "/coc"
endif
" ------------------------
" coc root_patterns
" ------------------------
autocmd FileType css,html let b:coc_additional_keywords = ["-"] + g:root_patterns
autocmd FileType php let b:coc_root_patterns = ['.htaccess', '.phpproject'] + g:root_patterns
autocmd FileType javascript let b:coc_root_patterns = ['.jsproject'] + g:root_patterns
autocmd FileType java let b:coc_root_patterns = ['.javasproject'] + g:root_patterns
autocmd FileType python let b:coc_root_patterns = ['.pyproject'] + g:root_patterns
autocmd FileType c,cpp let b:coc_root_patterns = ['.htaccess', '.cproject'] + g:root_patterns
" ----------------------------
" basic config
" ----------------------------
augroup cocgroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end
" ----------------------------
" semanticTokens
" ----------------------------
if Installed('nvim-treesitter', 'nvim-treehopper')
    let g:coc_default_semantic_highlight_groups = 0
else
    " semanticTokensFiletypes
    let g:coc_default_semantic_highlight_groups = 1
    call coc#config('semanticTokens.filetypes',  g:highlight_filetypes)
    " trseesiter
    nmap <C-s> <Plug>(coc-range-select)
    xmap <C-s> <Plug>(coc-range-select)
    omap <C-s> <Plug>(coc-range-select)
endif
" ------------------------
" icons
" ------------------------
if Installed('nvim-web-devicons')
    call coc#config('explorer.icon.source',  'nvim-web-devicons')
elseif Installed('vim-devicons')
    call coc#config('explorer.icon.source',  'vim-devicons')
endif
" ----------------------------
" extensions
" ----------------------------
let g:coc_global_extensions = [
        \ 'coc-lists',
        \ 'coc-marketplace',
        \ 'coc-snippets',
        \ 'coc-explorer',
        \ 'coc-pairs',
        \ 'coc-yank',
        \ 'coc-highlight',
        \ 'coc-git',
        \ 'coc-json',
        \ 'coc-sql',
        \ 'coc-xml',
        \ 'coc-sh',
        \ 'coc-powershell',
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
    " ccls language
    if executable('ccls')
        call coc#config('languageserver.ccls', {
                    \ "command": "ccls",
                    \ "filetypes": g:c_filetypes,
                    \ "rootPatterns": g:root_patterns,
                    \ "initializationOptions": {
                        \ "cache": {
                        \ "directory": $HOME . "/.leovim.d/ccls"
                        \ }
                    \ }
                \ })
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
" ----------------------------
" map
" ----------------------------
nnoremap <M-l>o :Coc
nnoremap <silent><M-V>  :CocFzfList yank<Cr>
nnoremap <silent><M-l>e :CocList extensions<Cr>
nnoremap <silent><M-l>c :CocFzfList commands<Cr>
nnoremap <silent><M-l>. :CocFzfListResume<Cr>
nnoremap <silent><M-l>; :CocNext<CR>
nnoremap <silent><M-l>, :CocPrev<CR>
nnoremap <silent><M-h>. :call CocAction('repeatCommand')<Cr>
" hover
function! Show_documentation()
    if index(['vim', 'help'], &filetype) >= 0
        if Installed('leaderf')
            LeaderfHelpCword
        else
            execute 'h '.expand('<cword>')
        endif
    elseif CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction
nnoremap <silent> K :call Show_documentation()<CR>
" completion map
inoremap <silent><expr> <CR>  coc#pum#visible() ? coc#pum#stop() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB> coc#pum#visible() ?
            \ coc#_select_confirm() :
            \ coc#expandableOrJumpable() ?
                \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
                \ Has_Back_Space() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-o>A"
inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#stop() : "\<C-r>\""
inoremap <silent><expr> <C-space> coc#refresh()
inoremap <silent><expr> <C-@> coc#refresh()
" scroll check. NOTE:  vim-quickui already configed
imap <silent><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-j>"
imap <silent><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-k>"
xmap <silent><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\%"
xmap <silent><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\g%"
" call hierarchy
nnoremap <silent>gl :call CocAction('showIncomingCalls')<Cr>
nnoremap <silent>gh :call CocAction('showOutgoingCalls')<Cr>
nnoremap <silent>gt :call CocAction('showSubTypes')<Cr>
nnoremap <silent>gT :call CocAction('showSuperTypes')<Cr>
" --------------------------
" coc snippets
" --------------------------
let g:coc_snippet_next = "<C-f>"
let g:coc_snippet_prev = "<C-b>"
if Installed('ultisnips')
    call coc#config('snippets.userSnippetsDirectory', $LEOVIM_PATH . '/UltiSnips')
else
    call coc#config('snippets.ultisnips.enable',  v:false)
    call coc#config('snippets.ultisnips.pythonx', v:false)
endif
" ----------------------------
" actions
" ----------------------------
" fix
xmap <leader>x <Plug>(coc-fix-current)
nmap <leader>x <Plug>(coc-fix-current)
" foxmat
xmap <C-q> <Plug>(coc-format-selected)
nmap <C-q> <Plug>(coc-format)
" Use CTRL-s for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" Add `:Format` command to format current buffeX.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" ----------------------------
" codeLens and codeaction
" ----------------------------
if has('nvim') || has('patch-9.0.0252')
    hi! link CocCodeLens CocListBgGrey
    call coc#config('inlayHint.display', v:false)
    nnoremap <silent><M-I> :CocCommand document.toggleInlayHint<Cr>
    if has('nvim')
        nnoremap <silent><M-C> :CocCommand document.toggleCodeLens<Cr>
        call coc#config('codeLens.enable', v:true)
        call coc#config('codeLens.separator', "# \\\\")
    else
        call coc#config('codeLens.enable', v:false)
    endif
else
    call coc#config('codeLens.enable', v:false)
endif
nnoremap <silent>gr            <Plug>(coc-rename)
nnoremap <silent><leader>a<Cr> <Plug>(coc-codeaction-line)
xnoremap <silent><leader>a<Cr> <Plug>(coc-codeaction-selected)
nnoremap <silent><leader>A     :CocFzfList actions<Cr>
" ------------------------
" Create mappings for function text object
" requires document symbols feature of languageserver.
" ------------------------
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" class
xmap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ic <Plug>(coc-classobj-i)
omap ac <Plug>(coc-classobj-a)
" ------------------------
" coc git
" ------------------------
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)
nmap <leader>vg vig
nmap <leader>vG vag
" ------------------------
" coc-fzf
" ------------------------
if Installed('coc-fzf')
    let g:coc_fzf_preview = ''
    let g:coc_fzf_opts = []
    let g:coc_fzf_preview_toggle_key = 'ctrl-/'
endif
" ------------------------
" coc config for nvim-0.8.1+
" ------------------------
" ------------------------
" mason
" ------------------------
nnoremap <silent><M-l>M :CocFzfList marketplace<Cr>
if has('nvim')
    if Installed('mason.nvim', 'mason-lspconfig.nvim')
        nnoremap <silent><M-l>m :Mason<Cr>
        lua << EOF
        require('mason').setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
            }
        })
        require('mason-lspconfig').setup({})
EOF
    endif
    if has('nvim-0.8.1')
        call coc#config("coc.preferences.currentFunctionSymbolAutoUpdate", v:false)
        luafile $LUA_PATH/coc.lua
    endif
else
    if WINDOWS()
        let $PATH = $NVIM_DATA_PATH . "\\mason\\bin;" . $PATH
    else
        let $PATH = $NVIM_DATA_PATH . "/mason/bin:" . $PATH
    endif
    call coc#config("coc.preferences.currentFunctionSymbolAutoUpdate", v:true)
endif
