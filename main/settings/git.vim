" cd git project root
command! CR cd %:h | cd `git rev-parse --show-toplevel`
nnoremap cr :CR<CR>
" fugitve and others
if Installed('vim-fugitive')
    nnoremap <M-G>  :G<tab>
    nnoremap <M-g>m :Git commit -av<Cr>
    nnoremap <M-g>i :Git<Space>
    nnoremap <M-g>u :Git push<CR>
    nnoremap <M-g>U :Git push<Space>
    " compare with history version
    let g:fugitive_summary_format = "%as-[%an]: %s"
    nnoremap <M-g>h :Git log --pretty=format:"%h\|\|%as-[%an]: %s" -- %<cr>
    nnoremap <M-g>d 0"ayiw:bw<cr>:rightbelow Gvdiff <c-r>a<cr>
    " gitblame
    nnoremap <silent> <M-g>b :Git blame<Cr>
    " git diff
    nnoremap <silent> <M-g>v :Gvdiffsplit<Cr>
    nnoremap <silent> <M-g>s :Gdiffsplit<Cr>
elseif Installed('asyncrun.vim') && g:has_terminal && UNIX()
    nnoremap <M-G> :AsyncRun -mode=term -focus=1 git status<Cr>
    nnoremap <M-g>m :AsyncRun -mode=term -focus=1 git commit -a -m ""<Left>
    nnoremap <M-g>i :AsyncRun -mode=term -focus=1 git<Space>
    nnoremap <M-g>u :AsyncRun -mode=term -focus=1 git push<Cr>
    nnoremap <M-g>U :AsyncRun -mode=term -focus=1 git push<Space>
else
    nnoremap <M-G> :!git status<Cr>
    nnoremap <M-g>m :!git commit -a -m ""<Left>
    nnoremap <M-g>i :!git<Space>
    nnoremap <M-g>u :!git push<Cr>
    nnoremap <M-g>U :!git push<Space>
endif
if Installed('blamer.nvim')
    let g:blamer_date_format = '%Y/%m/%d %H:%M'
    let g:blamer_show_in_insert_modes = 0
    let g:blamer_prefix = ' >> '
    nnoremap \\ :BlamerToggle<Cr>
endif
if InstalledTelescope()
    nnoremap <M-g>c :Telescope git_bcommits<Cr>
    nnoremap <M-g>f :Telescope git_files<CR>
elseif InstalledFzf()
    if Installed('coc.nvim') && WINDOWS()
        nnoremap <M-g>c :CocFzfList bcommits<Cr>
        nnoremap <M-g>f :CocFzfList gfiles<CR>
    else
        nnoremap <M-g>c :FzfBCommits<Cr>
        nnoremap <M-g>f :FzfGFiles?<CR>
    endif
endif
"########## Merge ##########{{{
let s:mergeSources = {
            \  'L':      1,
            \  'LOCAL':  1,
            \  'B':      2,
            \  'BASE':   2,
            \  'R':      3,
            \  'REMOTE': 3,
            \  'M':      4,
            \  'MERGE':  4,
            \}
function!  git#createMergeTab(...)
    " Map source name to buffer number
    if a:0 > 0
        let l:sources = []
        for item in a:000
            if has_key(s:mergeSources, toupper(item))
                call add(l:sources, get(s:mergeSources, toupper(item)))
            else
                echo 'Unrecognized source: ' . item
                return
            endif
        endfor
    else
        let l:sources = [1, 4, 3]
    endif
    let l:mergeBufIndex = max([index(l:sources, 4), 0]) + 1
    tabnew
    let i = 0
    while i < len(l:sources) - 1
        exec 'buf ' . l:sources[i]
        rightbelow vsp
        let i = i + 1
    endwhile
    exec 'buf ' . l:sources[i]
    windo diffthis
    exec l:mergeBufIndex . 'wincmd w'
endfunc
command! -nargs=* MergeTab call  git#createMergeTab(<f-args>)
nnoremap <M-g>t :MergeTab<space>
