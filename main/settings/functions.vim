function! TripTrailingWhiteSpace()
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ""
    endif
    let lines[-1] = lines[-1][:column_end - (&selection == "inclusive" ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
function! EscapedSearch() range
    let l:saved_reg = @"
    execute 'normal! vgvy'
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
function! Has_Back_Space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction
function! FileReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction
" --------------------------
" vim tabline
" --------------------------
function! Vim_NeatBuffer(bufnr, fullname)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
        if l:name == ''
            return '[No Name]'
        else
            if a:fullname
                return fnamemodify(l:name, ':p')
            else
                return fnamemodify(l:name, ':t')
            endif
        endif
    else
        let l:buftype = getbufvar(a:bufnr, '&buftype')
        if l:buftype == 'quickfix'
            return '[Quickfix]'
        elseif l:name != ''
            if a:fullname
                return '-'.fnamemodify(l:name, ':p')
            else
                return '-'.fnamemodify(l:name, ':t')
            endif
        else
            return '[No Name]'
        endif
    endif
endfunc
function! Vim_NeatTabLabel(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufnr = l:buflist[l:winnr - 1]
    return Vim_NeatBuffer(l:bufnr, 0)
endfun
" get a single tab label in gui
function! Vim_NeatGuiTabLabel()
    let l:num = v:lnum
    let l:buflist = tabpagebuflist(l:num)
    let l:winnr = tabpagewinnr(l:num)
    let l:bufnr = l:buflist[l:winnr - 1]
    return Vim_NeatBuffer(l:bufnr, 0)
endfunc
" --------------------------
" Execute function
" --------------------------
function! Execute(cmd)
    let cmd = a:cmd
    redir => output
    silent execute cmd
    redir END
    return output
endfunction
" --------------------------
" GetPyxVersion
" --------------------------
function! GetPyxVersion()
    if CYGWIN()
        return 0
    endif
    if has('python3')
        let l:pyx_version_raw = Execute('py3 print(sys.version)')
    elseif has('python')
        let l:pyx_version_raw = Execute('py print(sys.version)')
    else
        return 0
    endif
    let l:pyx_version_raw = matchstr(l:pyx_version_raw, '\v\zs\d{1,}.\d{1,}.\d{1,}\ze')
    if l:pyx_version_raw == ''
        return 0
    endif
    let l:pyx_version = StringToFloat(l:pyx_version_raw)
" --------------------------
" python import
" --------------------------
    if l:pyx_version > 3
python3 << Python3EOF
try:
    import vim
    import pygments
except Exception:
    pass
else:
    vim.command('let g:pygments_import = 1')
Python3EOF
    endif
    return l:pyx_version
endfunction
