local map = vim.api.nvim_set_keymap
require 'nvim-treesitter.configs'.setup {
  ensure_installed = vim.g.highlight_filetypes,
  sync_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
    disable = function(_, buf)
      local max_filesize = 1024 * 1024 -- 1m
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  matchup = {
    enable = true,
  },
  fold = {
    enable = true,
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
