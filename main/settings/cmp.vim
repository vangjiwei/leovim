let g:lsp_installer_servers = get(g:, 'lsp_installer_servers', ['pylsp']) + ['sumneko_lua', 'vimls']
if Require('c') || Require('ccls') || Require('clangd')
    let g:lsp_installer_servers += ['cmake']
    if executable('ccls') && !Require('clangd')
        let g:lsp_installer_servers += ['ccls']
    else
        let g:lsp_installer_servers += ['clangd']
    endif
endif
if Require('web')
    let g:lsp_installer_servers += ['cssls', 'tsserver', 'eslint', 'html', 'vuels', 'angularls']
endif
if Require('rust')
    let g:lsp_installer_servers += ['rust_analyzer']
endif
if Require('go')
    let g:lsp_installer_servers += ['gopls']
endif
if Require('R') && executable('R')
    let g:lsp_installer_servers += ['r_language_server']
endif
if Require('java') && executable('java')
    let g:lsp_installer_servers += ['jdtls']
endif
nnoremap <M-l>l :Lsp<Tab>
luafile $LUA_PATH/cmp-config.lua
