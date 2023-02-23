" --------------------------
" vimgrep in current file
" --------------------------
nnoremap \| :vimgrep <C-r>=expand('<cword>')<Cr> % \| copen<Cr>
xnoremap \| :vimgrep <C-r>=GetVisualSelection()<Cr> % \| copen<Cr>
" --------------------------
" eregex.vim
" --------------------------
let g:eregex_force_case     = 0
let g:eregex_default_enable = 1
let g:eregex_forward_delim  = ',/'
let g:eregex_backward_delim = ',?'
PackAdd 'eregex.vim'
" --------------------------
" vim-grepper
" --------------------------
if exists('*matchstrpos')
    let g:search_tool = 'grepper'
    nnoremap s<Tab> :Grepper
    nmap gR <plug>(GrepperOperator)
    xmap gR <plug>(GrepperOperator)
    let g:grepper = {
                \ 'open': 1,
                \ 'quickfix': 1,
                \ 'searchreg': 1,
                \ 'highlight': 0,
                \ 'repo': g:root_patterns
                \ }
    PackAdd 'vim-grepper'
    " self defined grepper commands
    function! s:grepper(...)
        if (a:1 == 2 || a:1 == 0 && a:2 == 1) && get(b:, 'git_root_path', '') != ''
            let grepper_cmd = 'GrepperGit'
            CR
        else
            let grepper_cmd = 'GrepperRg'
        endif
        " a:0 is the argments number of the function
        if a:1 == 0
            if a:2 == 0
                let search_str = get(g:, 'grepper_last_search', '')
            else
                let search_str = get(g:, 'grepper_all_last_search', '')
            endif
        else
            let search_str = substitute(a:2, '[\/]\+$', '', '')
            if a:1 == 1
                let g:grepper_last_search = search_str
            else
                let g:grepper_all_last_search = search_str
            endif
        endif
        if search_str == ''
            if a:1 == 1
                echo "Grepper search last str is empty"
            else
                echo "Grepper search all last str is empty"
            endif
            return
        else
            if grepper_cmd != 'GrepperGit'
                lcd %:p:h
            endif
            execute grepper_cmd . ' ' . search_str
            if grepper_cmd == 'GrepperGit'
                lcd %:p:h
            endif
        endif
    endfunction
    " Commands
    command! GrepperSearchLast    call s:grepper(0, 0)
    command! GrepperSearchAllLast call s:grepper(0, 1)
    command! -nargs=1 GrepperSearch    call s:grepper(1, <f-args>)
    command! -nargs=1 GrepperSearchAll call s:grepper(2, <f-args>)
    nnoremap <silent>s<Cr>      :GrepperSearchAll <C-r>=expand('<cword>')<Cr>
    xnoremap <silent>s<Cr>      :<C-u>GrepperSearchAll <C-r>=GetVisualSelection()<Cr>
    nnoremap <silent><silent>s. :GrepperSearchAllLast<Cr>
    nnoremap s'                 :GrepperSearchAll ""<left>
    " GrepperSearch
    nnoremap <silent>S<Cr> :GrepperSearch <C-r>=expand('<cword>')<Cr>
    xnoremap <silent>S<Cr> :<C-u>GrepperSearch <C-r>=GetVisualSelection()<Cr>
    nnoremap <silent>S.    :GrepperSearchLast<Cr>
    nnoremap S'            :GrepperSearch ""<Left>
    " cdo for replace
    cnoremap <M-r> cdo s///gc<Left><Left><Left>
    cnoremap <M-S> cfdo up
    " r as cdo replace
    au FileType qf nnoremap <buffer>r :cdo s///gc<Left><Left><Left>
    au FileType qf nnoremap <buffer><M-r> :cdo s///gc<Left><Left><Left>
    au FileType qf nnoremap <buffer><M-S> :cfdo up
    " using greppgit or grepperrg to find note or todo
    function! s:grepper_patterns_search(patterns)
        if get(b:, 'git_root_path', '') == ''
            execute printf('GrepperRg -e "%s:"', a:patterns)
        else
            execute printf('GrepperGit -E "%s:"', a:patterns)
        endif
    endfunction
    command! TODO call s:grepper_patterns_search(g:todo_patterns)
    command! NOTE call s:grepper_patterns_search(g:note_patterns)
    nnoremap <C-f>t :TODO<Cr>
    nnoremap <C-f>n :NOTE<Cr>
endif
" --------------------------
" searchall in telescope or fzf
" --------------------------
if InstalledTelescope()
    let g:search_tool = 'grepper-telescope'
    function! s:telescope_search(...) abort
        " a:0 代表参数数量, a1 代表第一个参数
        lcd %:p:h
        if a:0 == 0 || a:1 == 0
            Telescope live_grep
        else
            " a:1 == 1, normal search
            if a:1 == 1
                if a:0 == 1
                    let search_str = get(g:, 'telescope_search_last', '')
                else
                    let search_str = substitute(a:2, '[\/]\+$', '', '')
                    let g:telescope_search_last = search_str
                endif
            " a:1 > 1, searchall
            else
                if a:0 == 1
                    let search_str = get(g:, 'telescope_searchall_last', '')
                else
                    let search_str = substitute(a:2, '[\/]\+$', '', '')
                    let g:telescope_searchall_last = search_str
                endif
            endif
            " do the search
            if search_str == ''
                if a:1 == 1
                    echo 'telescope search last is empty'
                else
                    echo 'telescope search all last is empty'
                endif
            else
                if a:1 == 1
                    let dir = "./"
                else
                    let dir = substitute(expand(get(b:, 'git_root_path', './')), "\\", "/", "g")
                endif
                let g:telescope_seach = printf('require("telescope.builtin").grep_string({search = "%s", cwd = "%s"})', search_str, dir)
                call luaeval(g:telescope_seach)
            endif
        endif
    endfunction
    command! TeleFlyGrep call s:telescope_search(0)
    command! TeleSearchLast call s:telescope_search(1)
    command! -nargs=1 TeleSearch call s:telescope_search(1, <f-args>)
    command! TeleSearchAllLast call s:telescope_search(2)
    command! -nargs=1 TeleSearchAll call s:telescope_search(2, <f-args>)
    " searchall
    let g:search_all_cmd = 'TeleSearchAll'
    nnoremap s; :TeleSearchAll <C-r>=expand('<cword>')<Cr>
    xnoremap s; :<C-u>TeleSearchAll <C-r>=GetVisualSelection()<Cr>
    nnoremap <silent>s/ :TeleSearchAll <C-r>=expand('<cword>')<Cr><Cr>
    xnoremap <silent>s/ :<C-u>TeleSearchAll <C-r>=GetVisualSelection()<Cr><Cr>
    nnoremap <silent>s, :TeleSearchAllLast<Cr>
    " search
    nnoremap S; :TeleSearch <C-r>=expand('<cword>')<Cr>
    xnoremap S; :<C-u>TeleSearch <C-r>=GetVisualSelection()<Cr>
    nnoremap <silent>S/ :TeleSearch <C-r>=expand('<cword>')<Cr><Cr>
    xnoremap <silent>S/ :<C-u>TeleSearch <C-r>=GetVisualSelection()<Cr><Cr>
    nnoremap <silent>S, :TeleSearchLast<Cr>
elseif InstalledFZF() && exists('*systemlist')
    if get(g:, 'search_tool', '') == 'grepper'
        let g:search_tool = 'grepper-fzfsearch'
    else
        let g:search_tool = 'fzfsearch'
    endif
    function! s:fzf_search(...)
        if a:1 == 2 && get(b:, 'git_root_path', '') != ''
            let fzf_cmd = 'FZFGGrep'
        else
            let fzf_cmd = 'FZFRg'
        endif
        " a:0 代表参数数量, a1 代表 第一个参数
        lcd %:p:h
        if a:1 == 0
            " FZFFlyGrep
            execute fzf_cmd
        else
            " fzfsearch, a:1 == 1
            if a:1 == 1
                if a:0 == 1
                    let search_str = get(g:, 'fzf_search_last', '')
                else
                    let search_str = substitute(a:2, '[\/]\+$', '', '')
                    let g:fzf_search_last = search_str
                endif
            " fzfsearchall, a:1 == 2
            else
                if a:0 == 1
                    let search_str = get(g:, 'fzf_searchall_last', '')
                else
                    let search_str = substitute(a:2, '[\/]\+$', '', '')
                    let g:fzf_searchall_last = search_str
                endif
            endif
            " do the search
            if search_str == ''
                if a:0 == 1
                    echo 'fzf search last is empty'
                else
                    echo 'fzf search str is empty'
                endif
                return
            else
                execute fzf_cmd . ' ' . search_str
            endif
        endif
    endfunction
    command! FZFFlyGrep call s:fzf_search(0)
    command! FZFSearchLast call s:fzf_search(1)
    command! -nargs=1 FZFSearch call s:fzf_search(1, <f-args>)
    command! FZFSearchAllLast call s:fzf_search(2)
    command! -nargs=1 FZFSearchAll call s:fzf_search(2, <f-args>)
    " searchall
    let g:search_all_cmd = 'FZFSearchAll'
    nnoremap s; :FZFSearchAll <C-r>=expand('<cword>')<Cr>
    xnoremap s; :<C-u>FZFSearchAll <C-r>=GetVisualSelection()<Cr>
    nnoremap <silent>s/ :FZFSearchAll <C-r>=expand('<cword>')<Cr><Cr>
    xnoremap <silent>s/ :<C-u>FZFSearchAll <C-r>=GetVisualSelection()<Cr><Cr>
    nnoremap <silent>s, :FZFSearchAllLast<Cr>
    " search
    nnoremap S; :FZFSearch <C-r>=expand('<cword>')<Cr>
    xnoremap S; :<C-u>FZFSearch <C-r>=GetVisualSelection()<Cr>
    nnoremap <silent>S/ :FZFSearch <C-r>=expand('<cword>')<Cr><Cr>
    xnoremap <silent>S/ :<C-u>FZFSearch <C-r>=GetVisualSelection()<Cr><Cr>
    nnoremap <silent>S, :FZFSearchLast<Cr>
elseif get(g:, 'search_tool', '') =~ 'grepper'
    let g:search_all_cmd = 'GrepperSearchAll'
else
    let g:search_tool = 'vimgrep'
    nnoremap s/ :vimgrep "<C-r>=expand('<cword>')<Cr>" * \| copen<Cr>
    xnoremap s/ :<C-u>vimgrep "<C-r>=GetVisualSelection()" * \| copen<Cr>
endif
" --------------------------
" fuzzysearch with rg
" --------------------------
if Installed('leaderf')
    if exists('g:search_tool')
        let g:search_tool .= "-leaderfrg"
    else
        let g:search_tool = "leaderfrg"
        xnoremap s<Cr> :<C-u>Leaderf --stayOpen rg -L -S "<C-r>=GetVisualSelection()<CR>"<Cr>
        nnoremap s<Cr> :Leaderf --stayOpen rg -L -S "<C-r>=expand('<cword>')<Cr>"<CR>
    endif
    let g:Lf_RgConfig = [
        \ "--max-columns=10000",
        \ "--glob=!git/*",
        \ "--hidden"
    \ ]
    let g:Lf_RgStorePattern = "e"
    if get(g:,'Lf_PreviewInPopup', 0) == 1
        let g:Lf_Rg_pos = "popup"
    else
        let g:Lf_Rg_pos = "bottom"
    endif
    " flygrep recall
    nnoremap <leader>/ :Leaderf rg -L -S<Cr>
    nnoremap <leader>? :Leaderf rg -L -S <C-r>=expand('<cword>')<Cr>
    xnoremap <leader>? :<C-u>Leaderf rg -L -S <C-r>=GetVisualSelection()<Cr>
    " next previous
    nnoremap <C-f>; :Leaderf rg --next<Cr>
    xnoremap <C-f>; :<C-U>Leaderf rg --next<Cr>
    nnoremap <C-f>, :Leaderf rg --previous<Cr>
    xnoremap <C-f>, :<C-u>Leaderf rg --previous<Cr>
    " C-f map
    xnoremap <C-f>/ :<C-U>Leaderf rg<Space>
    nnoremap <C-f>/ :Leaderf rg<Space>
    xnoremap <C-f>. :<C-u>Leaderf rg --recal<Cr>
    nnoremap <C-f>. :Leaderf rg --recal<Cr>
    xnoremap <C-f>e :<C-u>Leaderf --stayOpen rg -L -S -e "<C-r>=GetVisualSelection()<CR>"
    nnoremap <C-f>e :Leaderf --stayOpen rg -L -S -e "<C-r>=expand('<cword>')<Cr>"
    xnoremap <C-f>b :<C-u>Leaderf --stayOpen rg -L -S --all-buffers "<C-r>=GetVisualSelection()<CR>"
    nnoremap <C-f>b :Leaderf --stayOpen rg -L -S --all-buffers "<C-r>=expand('<cword>')<Cr>"
    xnoremap <C-f>w :<C-u>Leaderf --stayOpen rg -L -S -w "<C-r>=GetVisualSelection()<CR>"
    nnoremap <C-f>w :Leaderf --stayOpen rg -L -S -w "<C-r>=expand('<cword>')<Cr>"
    xnoremap <C-f>f :<C-u>Leaderf --stayOpen rg -L -S -F "<C-r>=GetVisualSelection()<CR>"
    nnoremap <C-f>f :Leaderf --stayOpen rg -L -S -F "<C-r>=expand('<cword>')<Cr>"
    xnoremap <C-f>x :<C-u>Leaderf --stayOpen rg -L -S -x "<C-r>=GetVisualSelection()<CR>"
    nnoremap <C-f>x :Leaderf --stayOpen rg -L -S -x "<C-r>=expand('<cword>')<Cr>"
    xnoremap <C-f>a :<C-u>Leaderf --stayOpen rg --append "<C-r>=GetVisualSelection()<CR>"
    nnoremap <C-f>a :Leaderf --stayOpen rg --append "<C-r>=expand('<cword>')<Cr>"
    " interactive
    nnoremap <C-f>i :LeaderfRgInteractive<Cr>
    xnoremap <C-f>i :<C-u>LeaderfRgInteractive<Cr>
elseif InstalledTelescope()
    nnoremap <leader>/ :TeleFlyGrep<Cr>
    nnoremap <leader>. :TeleSearchLast<Cr>
    nnoremap <leader>? :TeleSearch <C-r>=expand('<cword>')<Cr>
    xnoremap <leader>? :<C-u>TeleSearch <C-r>=GetVisualSelection()<Cr>
elseif InstalledFZF()
    nnoremap <leader>/ :FZFFlyGrep<Cr>
    nnoremap <leader>. :FZFSearchLast<Cr>
    nnoremap <leader>? :FZFSearch <C-r>=expand('<cword>')<Cr>
    xnoremap <leader>? :<C-u>FZFSearch <C-r>=GetVisualSelection()<Cr>
endif
" ----------------------------
" bqf && quickui
" ----------------------------
if Installed('nvim-bqf')
    luafile $LUA_PATH/bqf.lua
    hi default link BqfPreviewFloat Normal
    hi default link BqfPreviewBorder Normal
    hi default link BqfPreviewCursor Cursor
    hi default link BqfPreviewRange IncSearch
    hi link BqfPreviewRange Search
    hi default BqfSign ctermfg=14 guifg=Cyan
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    aug Grepper
        au!
        au User Grepper call setqflist([], 'r',
                    \ {'context': {'bqf': {'pattern_hl': histget('/')}}}) |
                    \ botright copen
    aug END
    au FileType qf nmap <buffer> K :BqfToggle<Cr>
    au FileType qf nmap <buffer> i zf
else
    au FileType qf nnoremap <silent><buffer>P     :PreviewQuickfix<cr>
    au FileType qf nnoremap <silent><buffer><C-g> :PreviewQuickfix<cr>
    au FileType qf nnoremap <silent><buffer><C-m> :PreviewQuickfix e<Cr>
    au FileType qf nnoremap <silent><buffer><C-]> :PreviewQuickfix vsplit<Cr>
    au FileType qf nnoremap <silent><buffer><C-x> :PreviewQuickfix split<Cr>
    au FileType qf nnoremap <silent><buffer><C-t> :PreviewQuickfix tabe<Cr>
    if Installed('vim-quickui')
        au FileType qf nnoremap <silent><buffer> n j:call quickui#tools#preview_quickfix()<cr>
        au FileType qf nnoremap <silent><buffer> N k:call quickui#tools#preview_quickfix()<cr>
        " preview
        au FileType qf nnoremap <silent><buffer> K :call quickui#tools#preview_quickfix()<cr>
    endif
endif
" ----------------------------------
" ufo
" ----------------------------------
if Installed('nvim-ufo', 'promise-async')
  lua require('ufo').setup()
end
" ----------------------------------
" hl searchindex && multi replace
" ----------------------------------
try
    set shortmess+=S
catch
    " pass
endtry
if Installed('nvim-hlslens')
    lua require('hlslens').setup()
    nmap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
             \<Cmd>lua require('hlslens').start()<CR>
    nmap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
                \<Cmd>lua require('hlslens').start()<CR>
    nmap *  *<Cmd>lua require('hlslens').start()<CR>
    nmap #  #<Cmd>lua require('hlslens').start()<CR>
    nmap g* g*<Cmd>lua require('hlslens').start()<CR>
    nmap g# g#<Cmd>lua require('hlslens').start()<CR>
    nmap <C-n> *``cgn
else
    nmap *  *``
    nmap #  #``
    nmap g* g*``
    nmap g# g#``
    nmap <C-n> *cgn
endif
xmap <silent><C-n> :<C-u>call EnhancedSearch()<CR>/<C-R>=@/<CR><CR>gvc
