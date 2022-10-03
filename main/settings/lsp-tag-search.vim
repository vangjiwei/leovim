" --------------------------
" symbol_tool
" --------------------------
if len(g:symbol_group) > 0
    let g:symbol_tool = join(g:symbol_group, '-')
else
    let g:symbol_tool = ''
endif
unlet g:symbol_group
" --------------------------
" NOTE: directories must be defined before lsp_tag_search
" --------------------------
let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/.LfCache/gtags')
if isdirectory(g:gutentags_cache_dir)
    silent! call mkdir(g:gutentags_cache_dir, 'p')
endif
if get(g:, 'ctags_type', '') != ''
    let &tags = './.tags;,.tags'
    if WINDOWS()
        let g:fzf_tags_command = "ctags"
    else
        let g:fzf_tags_command = "ctags 2>/dev/null"
    endif
    " preview tag
    nnoremap <silent><M-:> :PreviewTag<Cr>
    if Installed('vim-quickui')
        nnoremap <silent><C-h> :call quickui#tools#preview_tag('')<Cr>
        nnoremap <silent><BS>  :call quickui#tools#preview_tag('')<Cr>
    else
        nnoremap <silent><C-h> :PreviewSignature!<Cr>
        nnoremap <silent><BS>  :PreviewSignature!<Cr>
    endif
    " show functions
    if g:symbol_tool =~ "leaderfctags"
        let g:Lf_Ctags = g:fzf_tags_command
        nnoremap <silent>f<Cr> :Leaderf function<Cr>
        nnoremap <silent>F<Cr> :Leaderf function --all<Cr>
        nnoremap <silent>t<Cr> :LeaderfBufTagAll<Cr>
        nnoremap <silent>T<Cr> :LeaderfTag<Cr>
    elseif g:symbol_tool =~ 'quickui'
        nnoremap <silent>f<Cr> :call quickui#tools#list_function()<Cr>
    endif
endif
" --------------------------
" symbols in buf
" --------------------------
if g:complete_engine == 'coc'
    let g:vista_default_executive = 'coc'
    if WINDOWS()
        if g:symbol_tool =~ 'leaderfctags'
            nnoremap <silent><M-t> :LeaderfBufTag<Cr>
        else
            nnoremap <silent><M-t> :Vista finder coc<Cr>
        endif
    else
        if get(g:, 'ctags_type', '') != ''
            nnoremap <silent><M-t> :CocFzfList outline<Cr>
            nnoremap <silent>ZO :Vista finder coc<Cr>
            nnoremap <silent>Zo :CocFzfList symbols<Cr>
        else
            nnoremap <silent><M-t> :Vista finder coc<Cr>
            nnoremap <silent>ZO :CocFzfList symbols<Cr>
        endif
    endif
elseif g:symbol_tool =~ 'leaderfctags'
    nnoremap <silent><M-t> :LeaderfBufTag<Cr>
elseif Installed('vista.vim')
    nnoremap <silent><M-t> :Vista finder!<Cr>
elseif g:symbol_tool =~ 'fzfctags'
    nnoremap <silent><M-t> :FzfBTags<Cr>
endif
" --------------------------
" siderbar tag config
" --------------------------
if Installed('tagbar')
    let g:tagbar_position = 'leftabove vertical'
    let g:tagbar_sort  = 0
    let g:tagbar_width = 35
    let g:tagbar_type_css = {
                \ 'ctagstype' : 'css',
                \ 'kinds' : [
                    \ 'c:classes',
                    \ 's:selectors',
                    \ 'i:identities'
                    \ ]}
elseif Installed('vista.vim')
    let g:vista_sidebar_position     = 'vertical topleft'
    let g:vista_sidebar_width        = 35
    let g:vista_echo_cursor          = 0
    let g:vista_stay_on_open         = 0
    let g:vista#renderer#enable_icon = 0
    let g:vista_icon_indent          = ["╰─▸ ", "├─▸ "]
    let g:vista_default_executive    = get(g:, 'vista_default_executive', 'ctags')
    if WINDOWS()
        let g:vista_fzf_preview = ['up:30%:hidden']
    else
        let g:vista_fzf_preview = ['up:30%']
    endif
endif
if Installed('vim-gutentags')
    set cscopetag
    " exclude files
    let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", "node_modules", "*.vim/bundle/*", ".ccls_cache", "__pycache__", ".idea", ".vscode"]
    " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    let g:gutentags_project_root = g:root_patterns
    " 所生成的数据文件的名称
    let g:gutentags_ctags_tagfile = '.tags'
    " modules
    let g:gutentags_modules = ['ctags']
    " 配置 ctags 的参数
    let g:gutentags_ctags_extra_args = ['--fields=+niazS']
    if g:ctags_type =~ "Universal"
        let g:gutentags_ctags_extra_args += ['--extras=+q', '--c-kinds=+px', '--c++-kinds=+px']
        if g:ctags_type =~ 'json'
            let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
        endif
    else
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px', '--c++-kinds=+pxI']
    endif
    nnoremap ,g<Cr> :GutentagsUpdate<Cr>
    if WINDOWS()
        nnoremap ,G :!del ~<Tab>\.leovim.d\.LfCache\gtags\*.* /a /q<Cr><Cr>
    else
        nnoremap ,G :!rm -rf ~/.leovim.d/.LfCache/gtags/* <Cr>
    endif
endif
" --------------------------
" gtags
" --------------------------
if get(g:, 'pygments_import', 0) > 0 && get(g:, 'native_pygments', 1) > 0 && get(g:, 'ctags_type', '') =~ 'Universal'
    let $GTAGSLABEL = 'native-pygments'
else
    let $GTAGSLABEL = 'native'
endif
if Installed('gutentags_plus')
    set cscopeprg=gtags-cscope
    let g:gutentags_modules += ['gtags_cscope']
    let g:gutentags_define_advanced_commands = 1
    let g:gutentags_plus_switch              = 1
    let g:gutentags_plus_nomap               = 1
    let g:gutentags_auto_add_gtags_cscope    = 1
    nnoremap <silent>,gs :GscopeFind s <C-R><C-W><cr>
    nnoremap <silent>,gg :GscopeFind g <C-R><C-W><cr>
    nnoremap <silent>,gd :GscopeFind d <C-R><C-W><cr>
    nnoremap <silent>,gc :GscopeFind c <C-R><C-W><cr>
    nnoremap <silent>,gt :GscopeFind t <C-R><C-W><cr>
    nnoremap <silent>,ge :GscopeFind e <C-R><C-W><cr>
    nnoremap <silent>,gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
    nnoremap <silent>,gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
    nnoremap <silent>,ga :GscopeFind a <C-R><C-W><cr>
    nnoremap <silent>,gz :GscopeFind z <C-R><C-W><cr>
endif
if g:symbol_tool =~ 'leaderfgtags'
    " leaderf gtags comparable
    let g:Lf_Gtagslabel          = $GTAGSLABEL
    let g:Lf_Gtagsconf           = $GTAGSCONF
    let g:Lf_GtagsSkipSymlink    = 'a'
    let g:Lf_GtagsAcceptDotfiles = 0
    let g:Lf_GtagsSkipUnreadable = 1
    let g:Lf_GtagsGutentags      = 1
    let g:Lf_GtagsAutoGenerate   = 0
    " create remove
    nnoremap <leader>g<Cr> :Leaderf gtags --update<Cr>
    nnoremap <leader>G     :Leaderf gtags --remove<Cr>
    " map
    nnoremap <leader>gt :Leaderf gtags<Space>
    nnoremap <silent><leader>g/ :Leaderf gtags --all<Cr>
    nnoremap <silent><leader>gb :Leaderf gtags --all-buffers<Cr>
    nnoremap <silent><leader>gc :Leaderf gtags --current-buffer<Cr>
    nnoremap <silent><leader>ga :Leaderf gtags --append<Cr>
    nnoremap <silent><leader>gr :Leaderf gtags -i -r <C-r><C-w><Cr>
    nnoremap <silent><leader>gs :Leaderf gtags -i -s <C-r><C-w><Cr>
    nnoremap <silent><leader>gg :Leaderf gtags -i -g <C-r><C-w><Cr>
    nnoremap <silent><leader>gd :Leaderf gtags -i -d <C-r><C-w><Cr>
    nnoremap <silent><leader>g; :Leaderf gtags --next<Cr>
    nnoremap <silent><leader>g, :Leaderf gtags --previous<Cr>
    nnoremap <silent><leader>g. :Leaderf gtags --recall<Cr>
endif
" --------------------------
" reference
" --------------------------
if Installed("coc.nvim")
    nmap <silent><M-/> :call LspOrTagOrSearch("jumpReferences")<Cr>
    nmap <silent><M-?> <Plug>(coc-refactor)
else
    if get(g:, 'symbol_tool', '') =~ 'leaderfgtags'
        nmap <silent><M-/> :Leaderf gtags -i -g <C-r><C-w><Cr>
    elseif get(g:, 'symbol_tool', '') =~ 'plus'
        nmap <silent><M-/> :GscopeFind g <C-R><C-W><cr>
    endif
endif
" --------------------------
" symbols jump
" --------------------------
function! s:open_in_postion(position) abort
    if a:position == 'vsplit'
        vsplit
        call Tools_PreviousCursor('ctrlo')
    elseif a:position == 'split'
        split
        call Tools_PreviousCursor('ctrlo')
    else
        split
        call Tools_PreviousCursor('ctrlo')
        execute("silent! normal \<C-w>T")
    endif
endfunction
function! s:settagstack(winnr, tagname, pos)
    call settagstack(a:winnr, {
                \ 'curidx': gettagstack()['curidx'],
                \ 'items': [{'tagname': a:tagname, 'from': a:pos}]
                \ }, 't')
endfunction
function! LspOrTagOrSearch(...) abort
    let tagname = expand('<cword>')
    let winnr   = winnr()
    let pos     = getcurpos()
    let pos[0]  = bufnr('')
    " coc
    if g:complete_engine == 'coc'
        let g:coc_locations_change = v:false
        " a:0, then number of other paragrams: ...
        if a:0 == 0
            let command = 'jumpDefinition'
            let ret = CocAction(command)
        else
            let command = trim(a:1)
            if a:0 == 1
                let ret = CocAction(command, v:false)
            else
                let ret = CocAction(command)
            endif
        endif
        if ret
            echo "found by coc " . command
            call s:settagstack(winnr, tagname, pos)
            if !g:coc_locations_change && a:0 > 1
                call s:open_in_postion(a:2)
            endif
        else
            let l:res = 0
        endif
    else
        let l:res = 0
    endif
    " tag
    if get(l:, 'res', 1) == 0
        if Installed('vim-gutentags')
            let ret = Execute("silent! PreviewList ". tagname)
            if ret =~ "E433" || ret =~ "E426" || ret =~ "E257"
                if get(g:, 'search_all_cmd', '') == ''
                    echom "No tag found, and cannot do global grep search."
                else
                    execute g:search_all_cmd . ' ' . tagname
                endif
            else
                execute "copen " . g:asyncrun_open
            endif
        " grep find
        elseif get(g:, 'search_all_cmd', '') != ''
            execute g:search_all_cmd . ' ' . tagname
        else
            echo "No ways to found " . tagname
        endif
    endif
endfunction
if g:complete_engine == 'coc'
    au User CocLocationsChange let g:coc_locations_change = v:true
    " jumpDefinition
    nnoremap <silent><C-]>  :call LspOrTagOrSearch()<Cr>
    nnoremap <silent><M-;>  :call LspOrTagOrSearch("jumpDefinition")<Cr>
    nnoremap <silent>gh     :call LspOrTagOrSearch("jumpDefinition", "split")<Cr>
    nnoremap <silent>g<Cr>  :call LspOrTagOrSearch("jumpDefinition", "vsplit")<Cr>
    nnoremap <silent>g<Tab> :call LspOrTagOrSearch("jumpDefinition", "tabe")<Cr>
    " jumpImplementation
    nnoremap <silent>gm :call LspOrTagOrSearch("jumpImplementation")<Cr>
    " jumpDeclaration
    nnoremap <silent>gl :call LspOrTagOrSearch("jumpDeclaration")<Cr>
    " jumpTypeDefinition
    nnoremap <silent>gt :call LspOrTagOrSearch("jumpTypeDefinition")<Cr>
else
    nnoremap <silent><M-;> :call LspOrTagOrSearch()<Cr>
endif
