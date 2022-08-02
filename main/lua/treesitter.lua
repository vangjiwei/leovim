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
if vim.fn['Installed']('nvim-treehopper') > 0 then
    vim.api.nvim_set_keymap('o', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
    vim.api.nvim_set_keymap('x', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
end
