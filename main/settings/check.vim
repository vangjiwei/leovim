if Installed('lspsaga.nvim')
    luafile $LUA_PATH/check.conf.lua
elseif Installed('coc.nvim')
    if has('nvim') || g:gui_running > 0
        let g:coc_diagnostic_messageTarget = "float"
        function! s:toggle_messagetarget() abort
            if g:coc_diagnostic_messageTarget == "float"
                let g:coc_diagnostic_messageTarget = "echo"
            else
                let g:coc_diagnostic_messageTarget = "float"
            endif
            echo "coc.diagnostic.messageTarget is " . g:coc_diagnostic_messageTarget
            call coc#config("diagnostic.messageTarget", g:coc_diagnostic_messageTarget)
        endfunction
        command! CocToggleDiagMessageTarget call s:toggle_messagetarget()
    endif
    if g:check_tool == 'ale'
        call coc#config('diagnostic.displayByAle', v:true)
    else
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
        nmap <silent>]d <Plug>(coc-diagnostic-next)
        nmap <silent>[d <Plug>(coc-diagnostic-prev)
        nmap <silent>]e <Plug>(coc-diagnostic-next-error)
        nmap <silent>[e <Plug>(coc-diagnostic-prev-error)
        " config ignore
        call coc#config('python.linting.flake8Args', [
                    \ "--max-line-length=200",
                    \ "--ignore=" . g:python_lint_ignore,
                    \ ])
        call coc#config('python.linting.pylintArgs', [
                    \ "--max-line-length=200",
                    \ "--ignore=" . g:python_lint_ignore,
                    \ ])
        " show/toggle diagnostic
        nmap <leader>ad <Plug>(coc-diagnostic-info)
        function! s:CocDiagnosticToggleBuffer()
            call CocAction('diagnosticToggleBuffer')
            if b:coc_diagnostic_disable > 0
                setlocal signcolumn=no
            else
                setlocal signcolumn=yes
            endif
        endfunction
        command! CocDiagnosticToggleBuffer call s:CocDiagnosticToggleBuffer()
        nnoremap <leader>d :CocDiagnosticToggleBuffer<Cr>
    endif
    " highlight group
    highlight def CocUnderLine cterm=NONE gui=NONE
    highlight def link CocErrorHighlight   NONE
    highlight def link CocWarningHighlight NONE
    highlight def link CocInfoHighlight    NONE
    highlight def link CocHintHighlight    NONE
endif
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
    let g:ale_sign_error         = 'E'
    let g:ale_sign_warning       = 'W'
    let g:ale_sign_hint          = 'H'
    let g:ale_sign_info          = 'I'
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
    let g:ale_python_flake8_options = "--max-line-length=200 --ignore=" . g:python_lint_ignore
    " map
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
    nnoremap <silent> <leader>D :ShowLint<Cr>
    nmap ]e <Plug>(ale_next_error)
    nmap [e <Plug>(ale_previous_error)
    nmap ]d <Plug>(ale_next)
    nmap [d <Plug>(ale_previous)
    nmap <leader>d :ALEToggle<Cr>
endif
