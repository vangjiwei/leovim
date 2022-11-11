let g:lsp_installer_servers = ['pylsp', 'vimls']
if Require('c')
    let g:lsp_installer_servers += ['cmake']
    if executable('clangd')
        let g:lsp_installer_servers += ['clangd']
    endif
    if executable('ccls')
        let g:lsp_installer_servers += ['ccls']
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
luafile $LUA_PATH/cmp.lua
