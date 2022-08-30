if Installed('ale')
    " basic settings
    let g:ale_disable_lsp                    = 1
    let g:ale_completion_enabled             = 0
    let g:ale_virtualtext_cursor             = 0
    let g:ale_pattern_options_enabled        = 1
    let g:ale_warn_about_trailing_whiteSpace = 0
    " lint time
    let g:ale_lint_on_enter           = 1
    let g:ale_lint_on_filetype_change = 1
    let g:ale_lint_on_insert_leave    = 0
    let g:ale_lint_on_save            = 1
    let g:ale_lint_on_text_changed    = 'normal'
    " signs
    let g:ale_set_signs          = 1
    let g:ale_sign_column_always = 0
    let g:ale_set_highlights     = 0
    let g:ale_sign_error         = ''
    let g:ale_sign_warning       = ''
    let g:ale_sign_hing          = ''
    let g:ale_sign_info          = ''
    " message format
    let g:ale_echo_msg_error_str   = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format      = '[%linter%] %s [%code%]'
    let g:ale_fix_on_save          = 0
    let g:ale_set_loclist          = 1
    let g:ale_set_quickfix         = 0
    let g:ale_statusline_format    = ['E:%d', 'W:%d', '']
    " linters
    let g:ale_linters = {
                \ 'python': ['flake8'],
                \ 'rust': ['cargo'],
                \ 'vue': ['vls'],
                \ 'zsh': ['shell']
                \ }
    let g:ale_python_flake8_options = "--max-line-length=160 --ignore=" . g:python_lint_ignore
    function! s:showLint() abort
        ALELint
        if UNIX() && g:has_popup_float
            FZFLocList
        elseif WINDOWS() && !has('nvim') && Installed('leaderf')
            lclose
            LeaderfLocList
        endif
    endfunction
    command! -bang -nargs=* ShowLint call s:showLint()
    if g:complete_engine == 'coc'
        call coc#config('diagnostic.enable', v:false)
        call coc#config('diagnostic.displayByAle', v:true)
    else
        nnoremap <silent> <leader>D :ShowLint<Cr>
        nmap ]d <Plug>(ale_next_error)
        nmap [d <Plug>(ale_previous_error)
        nmap <leader>d :ALEToggle<Cr>
    endif
elseif Installed('coc.nvim')
    " TODO: config signs
    call coc#config('diagnostic.displayByAle', v:false)
    call coc#config('diagnostic.enable', v:true)
    if WINDOWS()
        if has('nvim') || !has('nvim') && !Installed('leaderf')
            nnoremap <silent> <leader>D :CocDiagnostics<CR>
        elseif Installed('leaderf')
            nnoremap <silent> <leader>D :CocDiagnostics<CR>:lclose<Cr>:LeaderfLocList<Cr>
        else
            nnoremap <silent> <leader>D :CocFzfList diagnostics<CR>
        endif
    else
        nnoremap <silent> <leader>D :CocFzfList diagnostics<CR>
    endif
    nmap <silent>]d <Plug>(coc-diagnostic-next-error)
    nmap <silent>[d <Plug>(coc-diagnostic-prev-error)
    nmap <silent><leader>d :call CocAction('diagnosticToggle')<Cr>
    highlight def CocUnderLine cterm=NONE gui=NONE
    highlight def link CocErrorHighlight   CocUnderLine
    highlight def link CocWarningHighlight NONE
    highlight def link CocInfoHighlight    NONE
    highlight def link CocHintHighlight    NONE
    " config ignore
    call coc#config('python.linting.flake8Args', [
                \ "--max-line-length=160",
                \ "--ignore=" . g:python_lint_ignore,
                \ ])
    call coc#config('python.linting.pylintArgs', [
                \ "--max-line-length=160",
                \ "--ignore=" . g:python_lint_ignore,
                \ ])
endif
