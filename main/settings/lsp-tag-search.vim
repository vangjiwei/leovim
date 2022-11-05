" --------------------------
" symbol_tool
" --------------------------
if len(g:symbol_tool) > 0
    let s:symbol_tool = join(g:symbol_tool, '-')
else
    let s:symbol_tool = ''
endif
unlet g:symbol_tool
let g:symbol_tool=s:symbol_tool
unlet s:symbol_tool
" --------------------------
" NOTE: directories must be defined before lsp_tag_search
" --------------------------
let &tags = './.tags;,.tags'
let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/.LfCache/gtags')
if isdirectory(g:gutentags_cache_dir)
    silent! call mkdir(g:gutentags_cache_dir, 'p')
endif
" ctags with leaderf quickui
if get(g:, 'ctags_type', '') != ''
    if WINDOWS()
        let g:fzf_tags_command = "ctags"
    else
        let g:fzf_tags_command = "ctags 2>/dev/null"
    endif
    " show functions
    if g:symbol_tool =~ "leaderfctags"
        let g:Lf_Ctags = g:fzf_tags_command
        nnoremap <silent>F<Cr> :Leaderf function --all<Cr>
    endif
    if InstalledTelescope()
        nnoremap <silent>T<Cr> :Telescope tags<Cr>
    elseif g:symbol_tool =~ "leaderfctags"
        nnoremap <silent>T<Cr> :LeaderfTag<Cr>
    endif
    if g:complete_engine != 'cmp'
        if g:symbol_tool =~ "leaderfctags"
            nnoremap <silent>f<Cr> :Leaderf function<Cr>
            nnoremap <silent>t<Cr> :LeaderfBufTagAll<Cr>
        elseif Installed('vim-quickui')
            nnoremap <silent>f<Cr> :call quickui#tools#list_function()<Cr>
        endif
        " preview tag
        if Installed('vim-quickui')
            nnoremap <silent><M-:> :call quickui#tools#preview_tag('')<Cr>
        else
            nnoremap <silent><M-:> :PreviewTag<Cr>
        endif
    endif
endif
" --------------------------
" M-t is Specially defined
" --------------------------
function! PreviewTagOrSearchAll(tagname, ...)
    if a:tagname == ''
        let tagname = expand('<cword>')
    else
        let tagname = a:tagname
    endif
    if g:symbol_tool =~ 'leaderfgtags'
        let ret=Execute("silent! Leaderf gtags -i -g " . tagname)
        if let =~ 'not found'
            let ret = ''
            call feedkeys("\<ESC>", 'n')
        endif
    else
        let ret=''
    endif
    if ret =~ ''
        if a:0 == 0
            let tag_found = 0
        else
            let tag_found = a:1
        endif
        if InstalledTelescope() && index(['vim', 'help'], &ft) >= 0
            execute 'TeleSearchAll ' . tagname
        elseif g:ctags_type != '' && tag_found == 0
            if Installed('vim-gutentags')
                let ret = Execute("silent! PreviewList ". tagname)
            endif
            if ret =~ "E433" || ret =~ "E426" || ret =~ "E257"
                if get(g:, 'search_all_cmd', '') == ''
                    echom "No tag found, and cannot do global grep search."
                else
                    execute g:search_all_cmd . ' ' . tagname
                endif
            else
                execute "copen " . g:asyncrun_open
            endif
        elseif get(g:, 'search_all_cmd', '') != ''
            execute g:search_all_cmd . ' ' . tagname
        else
            echom "No tag found, and cannot do global grep search."
        endif
    endif
endfunction
command! PreviewTagOrSearchAll call PreviewTagOrSearchAll('')
nnoremap <silent><M-t> :PreviewTagOrSearchAll<Cr>
" --------------------------
" symbols in buf
" --------------------------
if g:complete_engine == 'coc'
    let g:vista_default_executive = 'coc'
    nnoremap <silent>ZL :CocFzfList symbols<Cr>
    if get(g:, 'ctags_type', '') == ''
        nnoremap <silent><leader>t :Vista finder coc<Cr>
    else
        if g:symbol_tool =~ 'leaderfctags'
            nnoremap <silent><leader>t :LeaderfBufTag<Cr>
        else
            nnoremap <silent><leader>t :CocFzfList outline<Cr>
        endif
        nnoremap <silent>ZO :Vista finder coc<Cr>
    endif
elseif g:complete_engine == 'cmp'
    nnoremap <silent><leader>t :Telescope current_buffer_tags<Cr>
else
    if g:symbol_tool =~ 'leaderfctags'
        nnoremap <silent><leader>t :LeaderfBufTag<Cr>
    elseif Installed('vista.vim')
        nnoremap <silent><leader>t :Vista finder!<Cr>
    elseif g:symbol_tool =~ 'fzfctags'
        nnoremap <silent><leader>t :FzfBTags<Cr>
    endif
endif
" --------------------------
" siderbar tag config
" --------------------------
if Installed('vista.vim')
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
        nnoremap ,g<Space> :!del ~<Tab>\.leovim.d\.LfCache\gtags\*.* /a /q<Cr><Cr>
    else
        nnoremap <leader>G :!rm -rf ~/.leovim.d/.LfCache/gtags/* <Cr>
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
    nnoremap <silent>,gs :GscopeFind s <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,gg :GscopeFind g <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,gd :GscopeFind d <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,gc :GscopeFind c <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,gt :GscopeFind t <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,ge :GscopeFind e <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
    nnoremap <silent>,gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
    nnoremap <silent>,ga :GscopeFind a <C-r>=expand('<cword>')<Cr><cr>
    nnoremap <silent>,gz :GscopeFind z <C-r>=expand('<cword>')<Cr><cr>
endif
if g:symbol_tool =~ 'leaderfgtags'
    " leaderf gtags comparable
    let g:Lf_Gtagslabel          = $GTAGSLABEL
    let g:Lf_GtagsSkipSymlink    = 'a'
    let g:Lf_GtagsAcceptDotfiles = 0
    let g:Lf_GtagsSkipUnreadable = 1
    let g:Lf_GtagsGutentags      = 1
    let g:Lf_GtagsAutoGenerate   = 0
    " create remove
    nnoremap <leader>g<Cr>    :Leaderf gtags --update<Cr>
    nnoremap <leader>g<space> :Leaderf gtags --remove<Cr>
    " map
    nnoremap <leader>gt :Leaderf gtags<Space>
    nnoremap <silent><leader>g/ :Leaderf gtags --all<Cr>
    nnoremap <silent><leader>gb :Leaderf gtags --all-buffers<Cr>
    nnoremap <silent><leader>gc :Leaderf gtags --current-buffer<Cr>
    nnoremap <silent><leader>ga :Leaderf gtags --append<Cr>
    nnoremap <silent><leader>gr :Leaderf gtags -i -r <C-r>=expand('<cword>')<Cr><Cr>
    nnoremap <silent><leader>gs :Leaderf gtags -i -s <C-r>=expand('<cword>')<Cr><Cr>
    nnoremap <silent><leader>gg :Leaderf gtags -i -g <C-r>=expand('<cword>')<Cr><Cr>
    nnoremap <silent><leader>gd :Leaderf gtags -i -d <C-r>=expand('<cword>')<Cr><Cr>
    nnoremap <silent><leader>g; :Leaderf gtags --next<Cr>
    nnoremap <silent><leader>g, :Leaderf gtags --previous<Cr>
    nnoremap <silent><leader>g. :Leaderf gtags --recall<Cr>
endif
" --------------------------
" lsp or references
" --------------------------
if g:complete_engine == 'cmp' && InstalledTelescope() && InstalledLsp() && InstalledCmp()
    luafile $LUA_PATH/lsp-search.lua
else
    if Installed("coc.nvim")
        nmap <silent><M-/> :call LspOrTagOrSearch("jumpReferences", "float")<Cr>
        nmap <silent><M-?> <Plug>(coc-refactor)
    else
        if get(g:, 'symbol_tool', '') =~ 'leaderfgtags'
            nmap <silent><M-/> :Leaderf gtags -i -g <C-r>=expand('<cword>')<Cr><Cr>
        elseif get(g:, 'symbol_tool', '') =~ 'plus'
            nmap <silent><M-/> :GscopeFind g <C-r>=expand('<cword>')<Cr><Cr>
        endif
    endif
endif
" --------------------------
" find wich coc or ctags
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
function! LspOrTagOrSearch(command, ...) abort
    let tagname = expand('<cword>')
    let winnr   = winnr()
    let pos     = getcurpos()
    let pos[0]  = bufnr('')
    let command = a:command
    if a:0 == 0
        let position = ''
    else
        let position = a:1
    endif
    " coc
    if g:complete_engine == 'coc' && command =~ 'jump'
        let g:coc_locations_change = v:false
        " a:0, then number of other paragrams: ...
        if position == 'float'
            let ret = CocAction(command, v:false)
        else
            let ret = CocAction(command)
        endif
        if ret
            echo "found by coc " . command
            let l:tag_found = 2
            call s:settagstack(winnr, tagname, pos)
            if !g:coc_locations_change
                call s:open_in_postion(position)
            endif
        else
            let l:tag_found = 0
        endif
    " tags
    elseif g:ctags_type != ''
        let ret = Execute("silent! tag ". tagname)
        if ret =~ "E433" || ret =~ "E426" || ret =~ "E257"
            let l:tag_found = 1
        else
            let l:tag_found = 2
            call s:settagstack(winnr, tagname, pos)
            call s:open_in_postion(position)
        endif
    else
        let l:tag_found = 0
    endif
    " tag_found == 0 : ctags not checked
    " tag_found == 1 : ctags checked but found none
    if get(l:, 'tag_found', 2) < 2
        call PreviewTagOrSearchAll(tagname, l:tag_found)
    endif
endfunction
if g:complete_engine == 'coc'
    au User CocLocationsChange let g:coc_locations_change = v:true
    " jumpDefinition
    nnoremap <silent><C-]>  :call LspOrTagOrSearch("jumpDefinition")<Cr>
    nnoremap <silent><M-;>  :call LspOrTagOrSearch("jumpDefinition", "float")<Cr>
    nnoremap <silent><C-g>  :call LspOrTagOrSearch("jumpDefinition", "vsplit")<Cr>
    nnoremap <silent>g<Cr>  :call LspOrTagOrSearch("jumpDefinition", "split")<Cr>
    nnoremap <silent>g<Tab> :call LspOrTagOrSearch("jumpDefinition", "tabe")<Cr>
    " jumpTypeDefinition
    nnoremap <silent>gh :call LspOrTagOrSearch("jumpTypeDefinition", "float")<Cr>
    " jumpDeclaration
    nnoremap <silent>gl :call LspOrTagOrSearch("jumpDeclaration", "float")<Cr>
    " jumpImplementation
    nnoremap <silent>gm :call LspOrTagOrSearch("jumpImplementation", "float")<Cr>
else
    if g:complete_engine != 'cmp'
        nnoremap <silent><M-;> :call LspOrTagOrSearch("")<Cr>
    endif
    nnoremap <silent><C-g>  :call LspOrTagOrSearch("", "vsplit")<Cr>
    nnoremap <silent>g<Cr>  :call LspOrTagOrSearch("", "split")<Cr>
    nnoremap <silent>g<Tab> :call LspOrTagOrSearch("", "tabe")<Cr>
endif
