" ----------------------------
" Disable file with size > 1MB
" ----------------------------
autocmd BufAdd * if getfsize(expand('<afile>')) > 1024*1024 |
            \ let b:coc_enabled=0 |
            \ endif
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
if UNIX()
    let g:coc_data_home = expand("~/.local/share/nvim/coc")
else
    let g:coc_data_home = expand("~/AppData/Local/nvim-data/coc")
endif
let g:coc_config_home = expand("$MAIN_PATH")
" basic map
nnoremap <M-l>c :Coc
nnoremap <silent><M-l>e :CocList extensions<Cr>
nnoremap <silent><M-l>. :CocFzfListResume<Cr>
nnoremap <silent><M-l>; :CocNext<CR>
nnoremap <silent><M-l>, :CocPrev<CR>
nnoremap <silent><M-l>C :CocFzfList commands<Cr>
nnoremap <silent><M-u>. :call CocAction('repeatCommand')<Cr>
nnoremap <silent><M-M>  :CocFzfList marketplace<Cr>
" completion map
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#stop() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ?
            \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
                \ Has_Back_Space() ? "\<TAB>" :
                    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#stop() : "\<C-y>"
inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
inoremap <silent><expr> <C-space> coc#refresh()
inoremap <silent><expr> <C-@> coc#refresh()
" scroll check
imap <silent><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-j>"
imap <silent><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-k>"
xmap <silent><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\%"
xmap <silent><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\g%"
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
nmap <C-s> <Plug>(coc-range-select)
xmap <C-s> <Plug>(coc-range-select)
omap <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffeX.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" refactor
nnoremap <silent><M-.> :call CocAction('showOutgoingCalls')<Cr>
nnoremap <silent><M-,> :call CocAction('showIncomingCalls')<Cr>
autocmd BufRead acwrite set ma
" ----------------------------
" codeLens and codeaction
" ----------------------------
if has('nvim') || has('patch-9.0.0252')
    nnoremap <silent><M-I> :CocCommand document.toggleInlayHint<Cr>
    hi! link CocCodeLens CocListBgGrey
    call coc#config('codeLens.enable', v:true)
    call coc#config('codeLens.separator', "# \\\\")
    call coc#config("typescript.inlayHints.variableTypes.enabled", v:true)
    call coc#config("typescript.inlayHints.parameterNames.enabled", "all")
    call coc#config("typescript.inlayHints.enumMemberValues.enabled", v:true)
    call coc#config("typescript.inlayHints.parameterTypes.enabled", v:true)
    call coc#config("typescript.inlayHints.functionLikeReturnTypes.enabled", v:true)
    call coc#config("typescript.inlayHints.propertyDeclarationTypes.enabled", v:true)
else
    call coc#config('codeLens.enable', v:false)
endif
nnoremap <silent><leader>a<Cr> <Plug>(coc-codeaction-line)
xnoremap <silent><leader>a<Cr> <Plug>(coc-codeaction-selected)
nnoremap <silent><leader>aa    <Plug>(coc-codeaction)
nnoremap <silent><leader>ar    <Plug>(coc-rename)
nnoremap <silent><leader>A     :CocFzfList actions<Cr>
" ------------------------
" Create mappings for function text object
" requires document symbols feature of languageserver.
" ------------------------
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
nmap <leader>vf vif
nmap <leader>vF vaf
" class
xmap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ic <Plug>(coc-classobj-i)
omap ac <Plug>(coc-classobj-a)
nmap <leader>vc vic
nmap <leader>vC vac
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
" coc c language
" ------------------------
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
" ------------------------
" coc fzf
" ------------------------
if Installed('coc-fzf') && InstalledFzf()
    if WINDOWS()
        let g:coc_fzf_preview=''
    else
        let g:coc_fzf_preview='right:60%'
    endif
endif
" ----------------------------
" semanticTokens
" ----------------------------
let g:coc_default_semantic_highlight_groups = 1
" semanticTokensFiletypes
call coc#config('semanticTokens.filetypes',  g:highlight_filetypes)
" ------------------------
" coc config for nvim-0.8
" ------------------------
if has('nvim-0.8')
    luafile $LUA_PATH/coc.conf.lua
endif
