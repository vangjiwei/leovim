" fold others rows and keep only the rows contain the search results
nmap <leader>zr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>
" basic fold
nmap <leader>zz zi
nmap ,zz        za
nmap <leader>za zfi{
nmap ,za        zfa{
nmap <leader>zi zfii
nmap ,zi        zfai
nmap <leader>zc zfic
nmap ,zc        zfac
nmap <leader>zf zfif
nmap ,zf        zfaf
nmap <leader>zb zfiB
nmap ,zb        zfaB
if Installed('nvim-ufo', 'promise-async')
    if Installed('mason.nvim')
        let s:map_ufo = 1
    elseif Installed('coc.nvim')
        let s:map_ufo = 1
        lua require('ufo').setup()
    elseif Installed('nvim-treesitter') && !Installed('mason.nvim')
        let s:map_ufo = 1
        lua require('ufo').setup({provider_selector = function(bufnr, filetype, buftype) return {'treesitter', 'indent'} end})
    endif
    if get(s:, 'map_ufo', 0) > 0
        nnoremap <leader>zo :lua require('ufo').openAllFolds()<Cr>
        nnoremap <leader>zm :lua require('ufo').closeAllFolds()<Cr>
        unlet s:map_ufo
    endif
endif
