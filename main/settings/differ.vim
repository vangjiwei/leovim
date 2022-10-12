" signify
if Installed('vim-signify')
    let g:signify_disable_by_default = 1
    nnoremap \<cr>    :SignifyDiff<Cr>
    nnoremap \<Space> :Signify
    nnoremap \<tab>   :SignifyToggle<Cr>
    nmap ]h <plug>(signify-next-hunk)
    nmap [h <plug>(signify-prev-hunk)
    omap im <plug>(signify-motion-inner-pending)
    xmap im <plug>(signify-motion-inner-visual)
    omap am <plug>(signify-motion-outer-pending)
    xmap am <plug>(signify-motion-outer-visual)
    nmap <leader>vm vim
    nmap <leader>vM vam
endif
" ZFVimDirDiff
if Installed('ZFVimDirDiff', 'ZFVimJob')
    nnoremap <leader>fm :ZFDirDiffMark<Cr>
    nnoremap <leader>fd :ZFDirDiff<Space>
endif
if Installed('ZFVimIgnore')
    autocmd User ZFIgnoreOnUpdate let &wildignore = join(ZFIgnoreToWildignore(ZFIgnoreGet()), ',')
endif
" ########## Diff Option ##########
try
    set diffopt+=context:20
    set diffopt+=internal,algorithm:patience
    let g:diff_algorithms = [
                \ "myers",
                \ "minimal",
                \ "patience",
                \ "histogram",
                \ ]
    let g:diff_algorithm = "patience"

    func! DiffSwitchAlgorithm()
        let l:total_diff_algos = len(g:diff_algorithms)
        let l:i = 0
        while l:i < l:total_diff_algos && g:diff_algorithms[l:i] !=# g:diff_algorithm
            let l:i += 1
        endwhile
        if l:i < l:total_diff_algos
            let g:diff_algorithm = g:diff_algorithms[(l:i + 1) % l:total_diff_algos]
        else
            let g:diff_algorithm = "patience"
        endif
        for l:algo in g:diff_algorithms
            exec "set diffopt-=algorithm:" . l:algo
        endfor
        exec "set diffopt+=algorithm:" . g:diff_algorithm
        echo "Diff algorithm switched to " . g:diff_algorithm
        windo diffupdate
    endfunc

    func! DiffUpdateContext(contextLines)
        let l:opt = substitute(&diffopt, '\v(^\|,)context:\d+', '', 'g') . ",context:" . a:contextLines
        exec "set diffopt=" . l:opt
        windo diffupdate
    endfunc

    func! DiffToggleWhiteSpace()
        if stridx(&diffopt, "iwhite") >= 0
            set diffopt-=iwhite
            echo "Not ignoring whitespaces in diff"
        else
            set diffopt+=iwhite
            echo "Whitespaces ignored in diff"
        endif
        windo diffupdate
    endfunc

    command! DiffSwitchAlgorithm call DiffSwitchAlgorithm()
    command! DiffToggleWhiteSpace call DiffToggleWhiteSpace()
    command! -nargs=1 DiffUpdateContext call DiffUpdateContext(<f-args>)
    nnoremap <leader>fDs :DiffSwitchAlgorithm<Cr>
    nnoremap <leader>fDt :DiffToggleWhiteSpace<Cr>
    nnoremap <leader>fDu :DiffUpdateContext<Space>
catch
    " pass
endtry
