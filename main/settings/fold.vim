" fold others rows and keep only the rows contain the search results
nmap <leader>zr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>
" basic fold
nmap <leader>zz za
nmap ,zz        za
nmap <leader>zo zfi{
nmap ,zo        zfa{
nmap <leader>zi zfii
nmap ,zi        zfai
nmap <leader>zc zfic
nmap ,zc        zfac
nmap <leader>zf zfif
nmap ,zf        zfaf
nmap <leader>zb zfiB
nmap ,zb        zfaB
