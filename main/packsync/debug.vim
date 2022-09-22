if CYGWIN()
    finish
endif
if g:advanced_complete_engine
    if has('nvim') && Require('debug') && !Require('vimspector')
        PackAdd 'mfussenegger/nvim-dap'
                    \| PackAdd 'mfussenegger/nvim-dap-python'
                    \| PackAdd 'rcarriga/nvim-dap-ui'
        if g:complete_engine == 'coc'
            PackAdd 'williamboman/mason.nvim'
        endif
    elseif (has('nvim') || v:version >= 802) && (Require('debug') || Require('vimspector')) && g:python_version > 3.6
        let vimspector_install = " ./install_gadget.py --update-gadget-config"
        PackAdd 'puremourning/vimspector', {'do': g:python_exe_path . vimspector_install}
    endif
endif
