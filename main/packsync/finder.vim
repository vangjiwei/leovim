" ------------------------------
" fuzzy_finder
" ------------------------------
if has('patch-7.4.330') && g:python_version > 2
    PackAdd 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension', 'opt': 0}
                \| PackAdd 'leoatchina/leaderf-registers'
                \| PackAdd 'leoatchina/leaderf-tabs'
                \| PackAdd 'Yggdroot/LeaderF-marks'
                \| PackAdd 'Yggdroot/LeaderF-changes'
    if g:floaterm_floating
        PackAdd 'voldikss/LeaderF-floaterm'
    endif
endif
if has('nvim-0.7') && g:complete_engine == 'cmp'
    PackAdd 'nvim-lua/plenary.nvim'
                \| PackAdd 'nvim-lua/popup.nvim'
                \| PackAdd 'MunifTanjim/nui.nvim'
                \| PackAdd 'nvim-neo-tree/neo-tree.nvim'
                \| PackAdd 'nvim-telescope/telescope.nvim'
                \| PackAdd 'nvim-telescope/telescope-ui-select.nvim'
                \| PackAdd 'nvim-telescope/telescope-symbols.nvim'
                \| PackAdd 'jeetsukumaran/telescope-buffer-lines.nvim'
    if UNIX() && executable('make')
        let g:telescope_fzf_make_cmd = get(g:, 'telescope_fzf_make_cmd', 'make')
    endif
    if get(g:, 'telescope_fzf_make_cmd', '') != ''
        PackAdd 'nvim-telescope/telescope-fzf-native.nvim', {'do': g:telescope_fzf_make_cmd, 'opt': 0}
    endif
    if !Planned('leaderf')
        PackAdd 'LinArcX/telescope-changes.nvim'
                    \| PackAdd 'dawsers/telescope-floaterm.nvim'
                    \| PackAdd 'GustavoKatel/telescope-asynctasks.nvim'
                    \| PackAdd 'TC72/telescope-tele-tabby.nvim'
    endif
else
    if WINDOWS()
        PackAdd 'junegunn/fzf', {'do': 'Powershell ./install.ps1 --all', 'dir': expand('$HOME\\AppData\\Local\\fzf')}
    else
        PackAdd 'junegunn/fzf', {'do': './install --all', 'dir': expand('~/.local/fzf')}
    endif
    PackAdd 'junegunn/fzf.vim' | PackAdd 'chengzeyi/fzf-preview.vim'
    if !Planned('leaderf')
        PackAdd 'pbogut/fzf-mru.vim'
                \| PackAdd 'leoatchina/fzf-tabs'
                \| PackAdd 'leoatchina/fzf-registers'
        if g:floaterm_floating
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
" quickui
" ------------------------------
if v:version >= 802 || has('nvim') && g:complete_engine != 'cmp'
    PackAdd 'skywind3000/vim-quickui'
endif
" ------------------------------
" zfvimdirdiff
" ------------------------------
PackAdd 'ZSaberLv0/ZFVimDirDiff'
PackAdd 'ZSaberLv0/ZFVimIgnore'
PackAdd 'ZSaberLv0/ZFVimJob'
