" basic fold
nmap <leader>za za
nmap <Tab>za    zA
nmap <leader>zz zfi{
nmap <Tab>zz    zfa{
nmap <leader>zi zfii
nmap <Tab>zi    zfai
nmap <leader>zc zfic
nmap <Tab>zc    zfac
nmap <leader>zf zfif
nmap <Tab>zf    zfaf
nmap <leader>zb zfiB
nmap <Tab>zb    zfaB
if Installed('nvim-ufo', 'promise-async')
    if Installed('coc.nvim')
        let s:map_ufo = 1
        lua require('ufo').setup()
    elseif InstalledCmp()
        let s:map_ufo = 1
    elseif Installed('nvim-treesitter')
        let s:map_ufo = 1
        lua require('ufo').setup({provider_selector = function(bufnr, filetype, buftype) return {'treesitter', 'indent'} end})
    endif
    if get(s:, 'map_ufo', 0) > 0
        nnoremap <leader>zo :lua require('ufo').openAllFolds()<Cr>
        nnoremap <leader>zm :lua require('ufo').closeAllFolds()<Cr>
        unlet s:map_ufo
    endif
endif
