if CYGWIN()
    finish
endif
if g:advanced_complete_engine && Require('debug')
    if has('nvim')
        PackAdd 'mfussenegger/nvim-dap'
                    \| PackAdd 'mfussenegger/nvim-dap-python'
                    \| PackAdd 'rcarriga/nvim-dap-ui'
        if g:complete_engine == 'coc'
            PackAdd 'williamboman/mason.nvim'
        endif
    elseif v:version >= 802 && !has('nvim') && g:python_version > 3.6
        let l:vimspector_install = " ./install_gadget.py --update-gadget-config"
        PackAdd 'puremourning/vimspector', {'do': g:python_exe_path . l:vimspector_install}
    endif
endif
