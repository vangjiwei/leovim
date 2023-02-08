" cd git project root
command! CR cd %:h | cd `git rev-parse --show-toplevel`
nnoremap cr :CR<CR>
" fugitve and others
if Installed('vim-fugitive')
    nnoremap <M-G>  :Git
    nnoremap <M-g>U :Git push<Space>
    nnoremap <silent><M-g>m :Git commit -av<Cr>
    nnoremap <silent><M-g>u :Git push<CR>
    " compare with history version
    let g:fugitive_summary_format = "%as-[%an]: %s"
    nnoremap <silent><M-g>h :Git log --pretty=format:"%h\|\|%as-[%an]: %s" -- %<cr>
    nnoremap <silent><M-g>g 0"ayiw:bw<cr>:rightbelow Gvdiff <c-r>a<cr>
    " gitblame
    nnoremap <silent><M-g>\ :Git blame<Cr>
    " git diff
    nnoremap <silent><M-g>d :Gvdiffsplit<Cr>
    nnoremap <silent><M-g>s :Gdiffsplit<Cr>
elseif Installed('asyncrun.vim') && g:has_terminal && UNIX()
    nnoremap <M-G>  :AsyncRun -mode=term -focus=1 git
    nnoremap <M-g>U :AsyncRun -mode=term -focus=1 git push<Space>
    nnoremap <M-g>m :AsyncRun -mode=term -focus=1 git commit -a -m ""<Left>
    nnoremap <M-g>u :AsyncRun -mode=term -focus=1 git push<Cr>
else
    nnoremap <M-G>  :!git
    nnoremap <M-g>U :!git push<Space>
    nnoremap <M-g>m :!git commit -a -m ""<Left>
    nnoremap <M-g>u :!git push<Cr>
endif
if Installed('blamer.nvim')
    let g:blamer_date_format = '%Y/%m/%d %H:%M'
    let g:blamer_show_in_insert_modes = 0
    let g:blamer_prefix = ' >> '
    nnoremap \\ :BlamerToggle<Cr>
endif
if Installed('gv.vim')
    nnoremap <silent><M-g>v :GV<Cr>
    nnoremap <silent><M-g>c :GV!<Cr>
    nnoremap <silent><M-g>r :GV?<Cr>
endif
if InstalledTelescope()
    nnoremap <M-g>b :Telescope git_bcommits<Cr>
    nnoremap <M-g>f :Telescope git_files<CR>
elseif InstalledFZF()
    if Installed('coc.nvim') && WINDOWS()
        nnoremap <M-g>b :CocFzfList bcommits<Cr>
        nnoremap <M-g>f :CocFzfList gfiles<CR>
    else
        nnoremap <M-g>b :FZFBCommits<Cr>
        nnoremap <M-g>f :FZFGFiles?<CR>
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
