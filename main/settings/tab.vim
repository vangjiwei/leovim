function! Map_Tab() abort
    if pumvisible()
        if Installed('ultisnips') && (UltiSnips#CanExpandSnippet() || UltiSnips#CanJumpForwards())
            return UltiSnips#ExpandSnippetOrJump()
        elseif Installed('vim-vsnip') && vsnip#available(1)
            return "normal \<Plug>(vsnip-expand-or-jump)"
        else
            return "\<C-n>"
        endif
    elseif Has_Back_Space()
        return "\<Tab>"
    else
        return "\<C-y>"
    endif
endfunction
au BufEnter * exec "imap <silent> <Tab> <C-R>=Map_Tab()<cr>"
