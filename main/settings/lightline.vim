"------------------------
" git related function
"------------------------
function! Gitbranch()
    return get(b:, 'git_branch', 'PATH')
endfunction
function! Rootpath()
    return get(b:, 'git_root_path', '')
endfunction
function! RootFilename()
    let root = Rootpath()
    let path = expand('%:p')
    if WINDOWS()
        return substitute(path[len(root):], '\\', '/', 'g')
    else
        return path[len(root):]
    endif
endfunction
function UpdateBufGit()
    if WINDOWS()
        let idx = -1
    else
        let idx = 0
    endif
    if g:git_version > 1.8
        let b:git_root_path = split(system('git rev-parse --show-toplevel'), "\\n")[idx]  . '/'
        if b:git_root_path =~ 'fatal:' && b:git_root_path =~ 'git'
            let b:git_root_path = ''
            let b:git_branch    = 'PATH'
        else
            if expand('%:t') !~ 'Tagbar\|Vista\|Gundo\|NERD\|coc\|fern' && &filetype !~ 'vimfiler' && &buftype !~ 'nofile'
                try
                    let b:git_branch = '@' . split(system('git rev-parse --abbrev-ref HEAD'), "\\n")[idx]
                    if b:git_branch =~ 'fatal:'
                        let b:git_branch = 'PATH'
                    endif
                catch /.*/
                    let b:git_branch = 'PATH'
                endtry
            else
                let b:git_branch = 'PATH'
            endif
        endif
    else
        let b:git_root_path = ''
        let b:git_branch    = 'PATH'
    endif
endfunction
augroup UpdateBufGit
    autocmd!
    autocmd WinEnter,BufCreate,BufEnter * call UpdateBufGit()
augroup END
"------------------------
" basic
"------------------------
let g:lightline = {
            \ 'component': {
              \ 'lineinfo': '%l/%L:%c'
            \ },
            \ 'component_function': {
              \ 'readonly':  'FileReadonly',
              \ 'gitbranch': 'Gitbranch',
              \ 'rootpath':  'Rootpath',
              \ 'filename':  'RootFilename',
            \ },
            \ 'active': {}
          \ }
"------------------------
" left part
"------------------------
if Installed('vista.vim')
    function! CurrentSymbol()
        return get(b:, 'coc_current_function', get(b:, 'vista_nearest_method_or_function', ''))
    endfunction
    let g:lightline.component_function.symbol = 'CurrentSymbol'
    let g:lightline.active.left = [['gitbranch', 'readonly', 'paste' ], ['rootpath'], ['filename', 'symbol', 'modified']]
else
    let g:lightline.active.left = [['gitbranch', 'readonly', 'paste' ], ['rootpath'], ['filename', 'modified']]
endif
"------------------------
" right part
"------------------------
let g:lightline.active.right = [['filetype', 'fileencoding', 'lineinfo']]
if Installed('lightline-ale')
    let g:lightline.component_expand =  {
                \ 'linter_checking': 'lightline#ale#checking',
                \ 'linter_errors': 'lightline#ale#errors',
                \ 'linter_warnings': 'lightline#ale#warnings',
                \ }
    let g:lightline.component_type = {
                \ 'linter_checking': 'right',
                \ 'linter_errors': 'error',
                \ 'linter_warnings': 'warning',
                \ }
    let s:lint_info = ['linter_checking', 'linter_errors', 'linter_warnings']
    let g:lightline.active.right += [s:lint_info]
elseif Installed('nvim-lightline-lsp')
    let g:lightline.component_expand = {
                \   'lsp_warnings': 'lightline#lsp#warnings',
                \   'lsp_errors': 'lightline#lsp#errors',
                \   'lsp_info': 'lightline#lsp#info',
                \   'lsp_hints': 'lightline#lsp#hints',
                \   'lsp_ok': 'lightline#lsp#ok',
                \ }
    " Set color to the components:
    let g:lightline.component_type = {
                \   'lsp_warnings': 'warning',
                \   'lsp_errors': 'error',
                \   'lsp_info': 'info',
                \   'lsp_hints': 'hints',
                \   'lsp_ok': 'left',
                \ }
    let s:lint_info = ['lsp_ok', 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings']
    let g:lightline.active.right += [s:lint_info]
elseif Installed('coc.nvim')
    function! CocDiagnostic()
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info) | return get(b:, 'coc_git_status', '')  | endif
        let msgs = []
        if get(info, 'error', 0)
            call add(msgs, 'E' . info['error'])
        endif
        if get(info, 'warning', 0)
            call add(msgs, 'W' . info['warning'])
        endif
        if get(info, 'hint', 0)
            call add(msgs, 'H' . info['hint'])
        endif
        return get(b:, 'coc_git_status', '') . ' ' . join(msgs, ' ')
    endfunction
    let g:lightline.component_function.coc_diag = 'CocDiagnostic'
    let g:lightline.active.right += [['coc_diag']]
endif
" ------------------------
" lightline themes
" ------------------------
function! UpdateLightline() abort
    if get(g:, 'colors_name', '') =~ 'code'
        let g:lightline.colorscheme = 'codedark'
    elseif get(g:, 'colors_name', '') =~ 'space'
        let g:lightline.colorscheme = 'simpleblack'
    elseif get(g:, 'colors_name', '') == 'sublime'
        let g:lightline.colorscheme = 'molokai'
    elseif get(g:, 'colors_name', '') == 'deus'
        let g:lightline.colorscheme = 'deus'
    elseif get(g:, 'colors_name', '') == 'hybrid'
        let g:lightline.colorscheme = 'nord'
    elseif get(g:, 'colors_name', '') == 'gruvbox'
        let g:lightline.colorscheme = 'gruvboxdark'
    elseif get(g:, 'colors_name', '') == 'gruvbox-material'
        let g:lightline.colorscheme = 'gruvbox_material'
    elseif get(g:, 'colors_name', '') == 'sonokai'
        let g:lightline.colorscheme = 'sonokai'
    elseif get(g:, 'colors_name', '') == 'edge'
        let g:lightline.colorscheme = 'edge'
    elseif get(g:, 'colors_name', '') == 'everforest'
        let g:lightline.colorscheme = 'everforest'
    elseif get(g:, 'colors_name', '') == 'nightfly'
        let g:lightline.colorscheme = 'nightfly'
    elseif get(g:, 'colors_name', '') =~ 'fox'
        let g:lightline.colorscheme = 'jellybeans'
    else
        let g:lightline.colorscheme = 'default'
    endif
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction
augroup UpdateLightline
    autocmd!
    autocmd ColorScheme * call UpdateLightline()
    autocmd WinEnter,VimEnter * call lightline#update()
    if Installed('coc.nvim')
        autocmd User CocGitStatusChange,CocDiagnosticChange call lightline#update()
    endif
augroup END
