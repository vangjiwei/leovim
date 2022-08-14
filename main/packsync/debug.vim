if CYGWIN()
    finish
endif
if v:version >= 801 && !has('nvim') && Require('termdebug') && executable('gdb')
    let g:debug_tool = 'termdebug'
    packadd termdebug
elseif g:advanced_complete_engine
    if has('nvim') && (Require('debug') || Require('nvim-dap'))
        " https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
        PackAdd 'mfussenegger/nvim-dap'
                    \| PackAdd 'rcarriga/nvim-dap-ui'
                    \| PackAdd 'theHamsta/nvim-dap-virtual-text'
                    \| PackAdd 'mfussenegger/nvim-dap-python'
        if get(g:, 'nvim_treesitter_install', 0) > 0 && g:complete_engine == 'cmp'
            PackAdd 'theHamsta/nvim-dap-virtual-text'
        endif
    elseif (has('nvim') || v:version >= 802) && (Require('debug') || Require('vimspector')) && g:python_version > 3.6
        let vimspector_install = " ./install_gadget.py --update-gadget-config"
        PackAdd 'puremourning/vimspector', {'do': g:python_exe_path . vimspector_install}
    endif
endif
