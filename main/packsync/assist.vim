" ------------------------------
" fuzzy_finder
" ------------------------------
if has('patch-7.4.330') && g:python_version > 2
    PackAdd 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension', 'opt': 0}
                \| PackAdd 'leoatchina/leaderf-registers'
                \| PackAdd 'Yggdroot/LeaderF-marks'
                \| PackAdd 'Yggdroot/LeaderF-changes'
    if g:floaterm_floating
        PackAdd 'voldikss/LeaderF-floaterm'
    endif
endif
if g:complete_engine == 'cmp'
    PackAdd 'nvim-lua/plenary.nvim'
                \| PackAdd 'MunifTanjim/nui.nvim'
                \| PackAdd 'nvim-neo-tree/neo-tree.nvim', {'branch', 'v2.x'}
                \| PackAdd 'nvim-telescope/telescope.nvim'
                \| PackAdd 'nvim-telescope/telescope-symbols.nvim'
    if UNIX() && executable('make')
        let g:telescope_fzf_make_cmd = get(g:, 'telescope_fzf_make_cmd', 'make')
    endif
    if get(g:, 'telescope_fzf_make_cmd', '') != ''
        PackAdd 'nvim-telescope/telescope-fzf-native.nvim', {'do': g:telescope_fzf_make_cmd, 'opt': 0}
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
if v:version >= 802 || has('nvim')
    PackAdd 'skywind3000/vim-quickui'
endif