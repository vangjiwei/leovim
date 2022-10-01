local map = vim.api.nvim_set_keymap
require 'nvim-treesitter.configs'.setup {
  ensure_installed = vim.g.highlight_filetypes,
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  matchup = {
    enable = true,
  },
  fold = {
    enable = false,
  },
  indent = {
    enable = false,
  },
  incrcmental_selection = {
    enable = false,
  }
}
require 'nvim-treesitter.install'.prefer_git = true
if Installed('nvim-treehopper') then
  map('o', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
  map('x', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
  map('n', '<C-s>', [[<cmd>lua require('tsht').nodes()<CR>]], { noremap = true, silent = true })
end
