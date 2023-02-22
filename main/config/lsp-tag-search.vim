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
try
    set tags=./.tags;,.tags
catch /.*/
    let &tags = './.tags;,.tags'
endtry
let g:gutentags_cache_dir = g:Lf_CacheDirectory.'/.LfCache/gtags'
if !isdirectory(g:gutentags_cache_dir)
    silent! call mkdir(g:gutentags_cache_dir, 'p')
endif
" --------------------------
" gutentags
" --------------------------
if Installed('vim-gutentags')
    set cscopetag
    " exclude files
    let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", "node_modules", "*.vim/bundle/*", ".ccls_cache", "__pycache__", ".idea", ".vscode"]
    " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    let g:gutentags_project_root = g:root_patterns
    let g:gutentags_add_default_project_roots = 0
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
        nnoremap ,g<Space> :!rm -rf ~/.leovim.d/.LfCache/gtags/* <Cr>
    endif
endif
" --------------------------
" symbols in buf
" --------------------------
if g:complete_engine == 'coc'
    let g:vista_default_executive = 'coc'
    nnoremap <silent>ZL :CocFzfList symbols<Cr>
    nnoremap <silent>ZO :CocFzfList outline<Cr>
    nnoremap <silent><leader>o :Vista finder coc<Cr>
elseif g:complete_engine != 'cmp' && g:ctags_type != ''
    if g:symbol_tool =~ 'leaderfctags'
        nnoremap <silent><leader>o :LeaderfBufTag<Cr>
    elseif Installed('vista.vim')
        let g:vista_default_executive = 'ctags'
        nnoremap <silent><leader>o :Vista finder!<Cr>
    elseif g:symbol_tool =~ 'fzfctags'
        nnoremap <silent><leader>o :FZFBTags<Cr>
    endif
endif
" --------------------------
" siderbar tag config
" --------------------------
if Installed('tagbar')
    let g:tagbar_position = 'leftabove vertical'
    let g:tagbar_sort  = 0
    let g:tagbar_width = 35
    let g:tagbar_autoclose_netrw = 1
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
    let g:gutentags_auto_add_gtags_cscope    = 0
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
" find wich lsp or tags
" --------------------------
function! s:settagstack(winnr, tagname, pos)
    if !exists('*settagstack') || !exists('*gettagstack')
        return
    endif
    if get(g:, 'check_settagstack', '') == ''
        try
            call settagstack(a:winnr, {
                        \ 'curidx': gettagstack()['curidx'],
                        \ 'items': [{'tagname': a:tagname, 'from': a:pos}]
                        \ }, 't')
            let g:check_settagstack = 't'
        catch /.*/
            call settagstack(a:winnr, {
                        \ 'curidx': gettagstack()['curidx'],
                        \ 'items': [{'tagname': a:tagname, 'from': a:pos}]
                        \ }, 'a')
            let g:check_settagstack = 'a'
        endtry
    else
        call settagstack(a:winnr, {
                    \ 'curidx': gettagstack()['curidx'],
                    \ 'items': [{'tagname': a:tagname, 'from': a:pos}]
                    \ }, g:check_settagstack)
    endif
endfunction
function! s:open_in_postion(position) abort
    if a:position == 'vsplit'
        vsplit
        call Tools_PreviousCursor('ctrlo')
    elseif a:position == 'split'
        split
        call Tools_PreviousCursor('ctrlo')
    elseif a:position == 'tabe'
        split
        call Tools_PreviousCursor('ctrlo')
        execute("silent! normal \<C-w>T")
    else
        return
    endif
endfunction
function! s:coc_jump(jumpCommand, position)
    let jumpCommand = a:jumpCommand
    try
        if a:position == 'float'
            let ret = CocActionSync(jumpCommand, v:false)
        else
            let ret = CocActionSync(jumpCommand)
        endif
    catch /.*/
        let ret = ''
    endtry
    if ret
        echohl WarningMsg | echom "found by coc " . jumpCommand | echohl None
    endif
    return ret
endfunction
function! LspOrTagOrSearchAll(...) abort
    let tagname = expand('<cword>')
    let winnr   = winnr()
    let pos     = getcurpos()
    let pos[0]  = bufnr('')
    if a:0 >= 1
        let l:postion = a:1
        if a:0 >= 2
            let l:command = a:2
        endif
    endif
    " coc
    if g:complete_engine == 'coc' && get(l:, 'command', '') =~ 'jump'
        let g:coc_locations_change = v:false
        if s:coc_jump(command, l:postion)
            silent! pclose
            let l:tag_found = 2
            call s:settagstack(winnr, tagname, pos)
            if !g:coc_locations_change && l:postion != ''
                call s:open_in_postion(l:postion)
            endif
            let ret = 1
        else
            let ret = 0
        endif
    else
        let ret = 0
    endif
    " tags
    if g:ctags_type != '' && ret == 0
        try
            let ret = preview#quickfix_list(tagname, 0, &filetype)
        catch /.*/
            let ret = 0
        endtry
        if ret == 1 && a:0 > 0
            silent! pclose
            execute "tag " . tagname
            call s:settagstack(winnr, tagname, pos)
            if g:complete_engine == 'coc'
                echohl WarningMsg | echom "Not found by coc " . l:command . " but found by ctags" | echohl None
            else
                echohl WarningMsg | echom "found by ctags" | echohl None
            endif
            if l:postion != ''
                call s:open_in_postion(l:postion)
            endif
        elseif ret > 0
            silent! pclose
            execute "copen " . g:asyncrun_open
        endif
        silent! redraw
    endif
    if ret == 0
        if get(g:, 'search_all_cmd', '') == ''
            echom "No tag found, and cannot do global grep search."
        else
            execute g:search_all_cmd . ' ' . tagname
        endif
    endif
endfunction
nnoremap <silent>g/ :call LspOrTagOrSearchAll()<Cr>
" --------------------------
" lsp or tag
" --------------------------
if Installed("coc.nvim")
    nmap <silent><M-/> :call LspOrTagOrSearchAll("jumpReferences", "float")<Cr>
    nmap <silent>gr <Plug>(coc-refactor)
    au User CocLocationsChange let g:coc_locations_change = v:true
    " jumpDefinition
    nnoremap <silent><C-g>  :call LspOrTagOrSearchAll("", "jumpDefinition")<Cr>
    nnoremap <silent><M-;>  :call LspOrTagOrSearchAll("float", "jumpDefinition")<Cr>
    nnoremap <silent><C-]>  :call LspOrTagOrSearchAll("vsplit", "jumpDefinition")<Cr>
    nnoremap <silent>g<Cr>  :call LspOrTagOrSearchAll("split", "jumpDefinition")<Cr>
    nnoremap <silent>g<Tab> :call LspOrTagOrSearchAll("tabe", "jumpDefinition")<Cr>
    " jumpImplementation
    nnoremap <silent><M-?> :call LspOrTagOrSearchAll("float", "jumpImplementation")<Cr>
    " jumpTypeDefinition
    nnoremap <silent><M-,> :call LspOrTagOrSearchAll("float", "jumpTypeDefinition")<Cr>
    " jumpDeclaration
    nnoremap <silent><M-.> :call LspOrTagOrSearchAll("float", "jumpDeclaration")<Cr>
else
    nnoremap <silent><C-]>  :call LspOrTagOrSearchAll("vsplit")<Cr>
    nnoremap <silent>g<Cr>  :call LspOrTagOrSearchAll("split")<Cr>
    nnoremap <silent>g<Tab> :call LspOrTagOrSearchAll("tabe")<Cr>
    if g:complete_engine == 'cmp' && InstalledTelescope() && InstalledLsp() && InstalledCmp()
        luafile $LUA_PATH/lsp.lua
    else
        nnoremap <silent><C-g> :call LspOrTagOrSearchAll("")<Cr>
        if get(g:, 'symbol_tool', '') =~ 'leaderfgtags'
            nmap <silent><M-/> :Leaderf gtags -i -g <C-r>=expand('<cword>')<Cr><Cr>
        elseif get(g:, 'symbol_tool', '') =~ 'plus'
            nmap <silent><M-/> :GscopeFind g <C-r>=expand('<cword>')<Cr><Cr>
        endif
    endif
    if g:search_tool =~ 'grepper'
        nnoremap <silent>gr :GrepperSearchAll <C-r>=expand('<cword>')<Cr><Cr>
    endif
endif
" --------------------------
" ctags with leaderf quickui
" --------------------------
if get(g:, 'ctags_type', '') != '' && g:complete_engine != 'cmp'
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
    if g:symbol_tool =~ "leaderfctags"
        nnoremap <silent>T<Cr> :LeaderfTag<Cr>
    endif
    if g:symbol_tool =~ "leaderfctags"
        nnoremap <silent>t<Cr> :LeaderfBufTagAll<Cr>
        nnoremap <silent>f<Cr> :Leaderf function<Cr>
    elseif Installed('vim-quickui')
        nnoremap <silent>f<Cr> :call quickui#tools#list_function()<Cr>
    endif
    " preview tag
    if Installed('vim-quickui')
        nnoremap <silent><M-:> :call quickui#tools#preview_tag('')<Cr>
    else
        nnoremap <silent><M-:> :PreviewTag<Cr>
    endif
    if g:complete_engine != 'coc'
        nnoremap <silent><M-;> :PreviewTag<Cr>
    endif
endif
