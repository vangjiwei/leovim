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
    nmap g/ :Dash<Space>
    nmap gs <Plug>DashSearch
    nmap gx <Plug>DashGlobalSearch
elseif Installed('zeavim.vim')
    nmap g/ :Zeavim<Space>
    nmap gs <Plug>Zeavim
    xmap gs <Plug>ZVVisSelection
    nmap gx <Plug>ZVKeyDocset
    nmap gz <Plug>ZVOperator
    omap gz <Plug>ZVOperator
endif
if Installed('vim-cppman')
    au FileType c,cpp,cuda nnoremap K :Cppman <C-r>=expand('<cword>')<Cr>
    au FileType c,cpp,cuda xnoremap K :<C-u>Cppman <C-r>=GetVisualSelection()<Cr>
endif
