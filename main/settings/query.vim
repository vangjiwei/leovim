if Installed('vim-translator')
    let g:translator_default_engines=['youdao', 'bing', 'haici']
    if g:has_popup_float
        " show translate in popup or floating windows
        nmap <silent> gw <Plug>TranslateW
        xmap <silent> gw <Plug>TranslateWV
    else
        nmap <silent> gw <Plug>Translate
        xmap <silent> gw <Plug>TranslateV
    endif
endif
if Installed('dash.vim')
    nmap Z: :Dash<Space>
    nmap Z? <Plug>DashSearch
    nmap ZK <Plug>DashGlobalSearch
elseif Installed('zeavim.vim')
    nmap Z: :Zeavim<Space>
    nmap Z? <Plug>Zeavim
    xmap Z? <Plug>ZVVisSelection
    nmap ZK <Plug>ZVKeyDocset
    nmap gz <Plug>ZVOperator
    omap gz <Plug>ZVOperator
endif
if Installed('coc.nvim')
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
endif
if Installed('vim-cppman')
    au FileType c,cpp,cuda nnoremap <M-k><M-k> :Cppman<Space>
    au FileType c,cpp,cuda nnoremap K :Cppman <C-r><C-w>
    au FileType c,cpp,cuda xnoremap K :<C-u>Cppman <C-r>=GetVisualSelection()<Cr>
endif
