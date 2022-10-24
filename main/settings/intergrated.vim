" ------------------------
" vim-eunuch
" ------------------------
PackAdd 'vim-eunuch'
" ------------------------
" Find merge conflict markers
" ------------------------
let g:conflict_marker_enable_mappings = 0
PackAdd 'conflict-marker.vim'
nnoremap <leader>cf /\v^[<\|=>]{7}( .*\|$)<CR>
nnoremap <leader>cF ?\v^[<\|=>]{7}( .*\|$)<CR>
nnoremap <leader>ct :ConflictMarkerThemselves<Cr>
nnoremap <leader>co :ConflictMarkerOurselves<Cr>
nnoremap <leader>ce :ConflictMarkerNone<Cr>
nnoremap <leader>cb :ConflictMarkerBoth<Cr>
nnoremap <leader>cn :ConflictMarkerNextHunk<Cr>
nnoremap <leader>cp :ConflictMarkerPrevHunk<Cr>
" --------------------------
" easyalign
" --------------------------
let g:easy_align_delimiters = {}
let g:easy_align_delimiters['#'] = {'pattern': '#', 'ignore_groups': ['String']}
let g:easy_align_delimiters['*'] = {'pattern': '*', 'ignore_groups': ['String']}
PackAdd 'vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap g, ga*,
xmap g= ga*=
xmap g: ga*:
xmap g<Space> ga*<Space>
" --------------------------
" matchup
" --------------------------
if get(g:, 'has_popup_float', 0) > 0
    let g:matchup_matchparen_offscreen = {'methed': 'popup'}
else
    let g:matchup_matchparen_offscreen = {'methed': 'status_manual'}
endif
PackAdd 'vim-matchup'
xnoremap <sid>(std-I) I
xnoremap <sid>(std-A) A
xmap <expr> I mode()=='<c-v>'?'<sid>(std-I)':(v:count?'':'1').'i'
xmap <expr> A mode()=='<c-v>'?'<sid>(std-A)':(v:count?'':'1').'a'
nnoremap <silent>M :MatchupWhereAmI??<Cr>
xnoremap <silent>M <ESC>:MatchupWhereAmI??<Cr>
function! s:matchup_convenience_maps()
    for l:v in ['', 'v', 'V', '<c-v>']
        execute 'omap <expr>' l:v.'I%' "(v:count?'':'1').'".l:v."i%'"
        execute 'omap <expr>' l:v.'A%' "(v:count?'':'1').'".l:v."a%'"
    endfor
endfunction
call s:matchup_convenience_maps()
" ------------------------
" easymotion
" ------------------------
let g:EasyMotion_keys = '123456789asdghklqwertyuiopzxcvbnmfj,;'
if exists('g:vscode')
    PackAdd 'vim-easymotion-vscode'
else
    PackAdd 'vim-easymotion'
endif
PackAdd 'vim-easymotion-chs'
source $SETTINGS_PATH/easymotion.vim
" ------------------------
" clever-f
" ------------------------
let g:clever_f_smart_case = 1
let g:clever_f_repeat_last_char_inputs = ['<Tab>']
PackAdd 'clever-f.vim'
nmap ; <Plug>(clever-f-repeat-forward)
xmap ; <Plug>(clever-f-repeat-forward)
if exists('g:vscode')
    nmap , <Plug>(clever-f-repeat-back)
    xmap , <Plug>(clever-f-repeat-back)
else
    nmap - <Plug>(clever-f-repeat-back)
    xmap - <Plug>(clever-f-repeat-back)
endif
" ------------------------
" surround
" ------------------------
nmap SL vg_S
nmap SH v^S
nmap SJ vt<Space>S
nmap SK vT<Space>S
nmap SS T<Space>vt<Space>S
" --------------------------
" textobj need 704+
" --------------------------
if v:version < 704
    finish
endif
" ------------------------
" textobj
" ------------------------
PackAdd 'vim-textobj-user'
PackAdd 'vim-textobj-syntax'
PackAdd 'vim-textobj-uri'
PackAdd 'vim-textobj-line'
nmap <leader>vf vif
nmap <leader>vF vaf
nmap <leader>vu viu
nmap <leader>vU vau
nmap <leader>vl vil
nmap <leader>vL val
nmap <leader>vt vi%
nmap <leader>vT va%
nmap <leader>va via
nmap <leader>vA vaa
nmap <leader>vi vii
nmap <leader>vI vai
" ------------------------
" goto first/last indent
" ------------------------
nmap si viio<C-[>^
nmap sg vii<C-[>^
" --------------------------
" sandwich
" --------------------------
PackAdd 'vim-sandwich'
xmap is <Plug>(textobj-sandwich-auto-i)
xmap as <Plug>(textobj-sandwich-auto-a)
omap is <Plug>(textobj-sandwich-auto-i)
omap as <Plug>(textobj-sandwich-auto-a)
xmap iq <Plug>(textobj-sandwich-query-i)
xmap aq <Plug>(textobj-sandwich-query-a)
omap iq <Plug>(textobj-sandwich-query-i)
omap aq <Plug>(textobj-sandwich-query-a)
nmap <leader>vs vis
nmap <leader>vS vas
nmap <leader>vq viq
nmap <leader>vQ vaq
" ------------------------
" find block
" ------------------------
if g:has_terminal
    let s:block_str = '^# In\[\d\{0,\}\]\|^# %%'
    function! BlockA()
        let beginline = search(s:block_str, 'ebW')
        if beginline == 0
            normal! gg
        endif
        let head_pos = getpos('.')
        let endline  = search(s:block_str, 'eW')
        if endline == 0
            normal! G
        endif
        let tail_pos = getpos('.')
        return ['V', head_pos, tail_pos]
    endfunction
    function! BlockI()
        let beginline = search(s:block_str, 'ebW')
        if beginline == 0
            normal! gg
            let beginline = 1
        else
            normal! j
        endif
        let head_pos = getpos('.')
        let endline = search(s:block_str, 'eW')
        if endline == 0
            normal! G
        elseif endline > beginline
            normal! k
        endif
        let tail_pos = getpos('.')
        return ['V', head_pos, tail_pos]
    endfunction
    " vib vab to select a block
    call textobj#user#plugin('block', {
                \   'block': {
                \     'select-a-function': 'BlockA',
                \     'select-a': 'aB',
                \     'select-i-function': 'BlockI',
                \     'select-i': 'iB',
                \     'region-type': 'V'
                \   },
                \ })
    nmap <leader>vb viB
    nmap <leader>vB vaB
endif
