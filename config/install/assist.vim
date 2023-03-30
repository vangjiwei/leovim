" ------------------------------
" fuzzy_finder
" ------------------------------
if has('patch-7.4.330') && g:python_version > 2
    PackAdd 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
                \| PackAdd 'leoatchina/leaderf-registers'
    if g:has_popup_floating
        PackAdd 'voldikss/LeaderF-floaterm'
    endif
    if v:version >= 800
        PackAdd 'Yggdroot/LeaderF-marks'
                \| PackAdd 'Yggdroot/LeaderF-changes'
    endif
endif
if g:complete_engine == 'cmp'
    PackAdd 'nvim-lua/plenary.nvim'
                \| PackAdd 'MunifTanjim/nui.nvim'
                \| PackAdd 'nvim-neo-tree/neo-tree.nvim', {'branch' : 'v2.x'}
                \| PackAdd 'nvim-telescope/telescope.nvim'
                \| PackAdd 'nvim-telescope/telescope-symbols.nvim'
    if UNIX() && executable('make')
        let g:telescope_fzf_make_cmd = get(g:, 'telescope_fzf_make_cmd', 'make')
    endif
    if get(g:, 'telescope_fzf_make_cmd', '') != ''
        PackAdd 'nvim-telescope/telescope-fzf-native.nvim', {'do': g:telescope_fzf_make_cmd}
    endif
    if !Planned('leaderf')
        PackAdd 'LinArcX/telescope-changes.nvim'
                    \| PackAdd 'jeetsukumaran/telescope-buffer-lines.nvim'
                    \| PackAdd 'dawsers/telescope-floaterm.nvim'
                    \| PackAdd 'GustavoKatel/telescope-asynctasks.nvim'
                    \| PackAdd 'LinArcX/telescope-changes.nvim'
    endif
else
    if WINDOWS()
        PackAdd 'junegunn/fzf', {'do': 'Powershell ./install.ps1 --all', 'dir': expand('$HOME\\AppData\\Local\\fzf')}
    else
        PackAdd 'junegunn/fzf', {'do': './install --all', 'dir': expand('~/.local/fzf')}
    endif
    PackAdd 'junegunn/fzf.vim'
    if !Planned('leaderf')
        PackAdd 'pbogut/fzf-mru.vim'
                \| PackAdd 'leoatchina/fzf-registers'
        if g:has_popup_floating
            PackAdd 'voldikss/fzf-floaterm'
        endif
    endif
endif
" ------------------------------
" search hl && index && notify
" ------------------------------
if has('nvim')
    PackAdd 'kevinhwang91/nvim-bqf'
    PackAdd 'kevinhwang91/nvim-hlslens'
    PackAdd 'rcarriga/nvim-notify'
else
    PackAdd 'vim-searchindex'
endif
" ------------------------------
" vim-preview and quickui
" ------------------------------
if v:version >= 802 || has('nvim')
    PackAdd 'vim-quickui'
endif
PackAdd 'vim-preview'
" ------------------------------
" devicons
" ------------------------------
if g:advanced_complete_engine
    if has('nvim')
        PackAdd 'nvim-tree/nvim-web-devicons'
    else
        PackAdd 'ryanoasis/vim-devicons'
    endif
endif
" ------------------------------
" cmdline complete
" ------------------------------
if has('nvim') && get(g:, "complete_engine", '') != 'cmp' || v:version >= 801 && !has('nvim')
    if has('nvim')
        function! UpdateRemotePlugins(...)
            " Needed to refresh runtime files
            let &rtp=&rtp
            UpdateRemotePlugins
        endfunction
        PackAdd 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
    else
        PackAdd 'gelguy/wilder.nvim'
    endif
endif
" ------------------------------
" zfvim
" ------------------------------
if (Require('wubi') || Require('pinyin')) && g:has_terminal > 0
    PackAdd 'ZSaberLv0/ZFVimIM'
    if Require('wubi')
        PackAdd 'ZSaberLv0/ZFVimIM_wubi_base'
        let g:input_method = 'zfvim_wubi'
    else
        let g:input_method = 'zfvim_pinyin'
    endif
    PackAdd 'ZSaberLv0/ZFVimIM_pinyin'
endif
PackAdd 'ZSaberLv0/ZFVimJob'
PackAdd 'ZSaberLv0/ZFVimIgnore'
PackAdd 'ZSaberLv0/ZFVimDirDiff'
