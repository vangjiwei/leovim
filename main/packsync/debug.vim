if CYGWIN()
    finish
endif
if g:advanced_complete_engine
    if (v:version >= 802 && (Require('debug') || Require('vimspector')) || has('nvim') && Require('vimspector')) && g:python_version > 3.6
        let vimspector_install = " ./install_gadget.py --update-gadget-config"
        PackAdd 'puremourning/vimspector', {'do': g:python_exe_path . vimspector_install}
    elseif has('nvim-0.7.2') && Require('debug')
        PackAdd 'mfussenegger/nvim-dap' | PackAdd 'rcarriga/nvim-dap-ui'
        if g:complete_engine == 'coc'
            PackAdd 'williamboman/mason.nvim'
        endif
    endif
endif
