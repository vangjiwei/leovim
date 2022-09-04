local map  = vim.api.nvim_set_keymap
require 'nvim-treesitter.configs'.setup {
    ensure_installed = vim.g.highlight_filetypes,
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = false,
    },
    fold = {
        enable = false,
    },
    incrcmental_selection = {
        enable = true,
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
    },
    matchup = {
        enable = true,
    }
}
require 'nvim-treesitter.install'.prefer_git = true
if installed('nvim-treehopper') then
    map('o', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
    map('x', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
    map('n', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
end
