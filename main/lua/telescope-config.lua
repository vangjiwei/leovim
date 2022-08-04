local telescope     = require('telescope')
local actions       = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
-- local pickers = require("telescope.pickers")
-- local sorters = require("telescope.sorters")
-- local finders = require("telescope.finders")
-- local previewers    = require("telescope.previewers")
-- fzf core
if vim.fn['Installed']('telescope-fzf-native.nvim') > 0 then
  telescope.setup {
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    }
  }
  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  telescope.load_extension('fzf')
end
telescope.setup {
  defaults = {
    layout_strategy  = 'flex',
    layout_config    = { prompt_position = "top" },
    sorting_strategy = 'ascending',
    scroll_strategy  = 'limit',
    mappings         = {
      i = {
        ["<C-j>"]  = actions.move_selection_next,
        ["<C-k>"]  = actions.move_selection_previous,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"]   = actions.move_selection_previous,
        ['<tab>']  = toggle_modes,
        ["<esc>"]  = actions.close,
        ["<C-c>"]  = actions.close,
        ["<M-q>"]  = actions.close,
        ['<C-s>']  = actions.toggle_selection,
        ['<C-q>']  = actions.send_to_qflist.open_qflist,
      },
      n = {
        ["<C-j>"]  = actions.move_selection_next,
        ["<C-k>"]  = actions.move_selection_previous,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"]   = actions.move_selection_previous,
        ['<tab>']  = toggle_modes,
        ["<esc>"]  = actions.close,
        ["<C-c>"]  = actions.close,
        ["<M-q>"]  = actions.close,
        ["<C-h>"]  = action_layout.toggle_preview,
        ['<C-s>']  = actions.toggle_selection,
        ['<C-q>']  = actions.send_to_qflist.open_qflist,
      },
    },
  },
}
-- rg
telescope.setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim"
    }
  }
}
-- keymaps
vim.api.nvim_set_keymap('n', '<leader>T', [[:Telescope ]], { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<M-l><M-l>', [[<cmd>Telescope current_buffer_fuzzy_find<Cr>]], { noremap = true, silent = true })
if vim.fn['Installed']('telescope-ultisnips.nvim') > 0 then
  telescope.load_extension('ultisnips')
  vim.api.nvim_set_keymap('i', '<C-x><C-x>', [[<ESC><cmd>Telescope ultisnips<CR>]], { noremap = true, silent = true })
elseif vim.fn['Installed']('telescope-luasnip.nvim') > 0 then
  telescope.load_extension('luasnip')
  vim.api.nvim_set_keymap('i', '<C-x><C-x>', [[<ESC><cmd>Telescope luasnip<CR>]], { noremap = true, silent = true })
end
if vim.fn['Installed']('telescope-changes.nvim') > 0 then
  telescope.load_extension('changes')
  vim.api.nvim_set_keymap('n', '<M-z>', [[<cmd>Telescope changes<CR>]], { noremap = true, silent = true })
end
if vim.fn['Installed']('telescope-floaterm.nvim') > 0 then
  telescope.load_extension('floaterm')
  vim.api.nvim_set_keymap('n', '<leader>w', [[<cmd>Telescope floaterm<CR>]], { noremap = true, silent = true })
end
if vim.fn['Installed']('telescope-ui-select.nvim') > 0 then
  telescope.load_extension("ui-select")
end
if vim.fn['Installed']('telescope-buffer-lines.nvim') > 0 then
  telescope.load_extension('buffer_lines')
  vim.api.nvim_set_keymap('i', '<C-x><C-l>', [[<ESC><cmd>Telescope buffer_lines<CR>]], { noremap = true, silent = true })
end
if vim.fn['Installed']('telescope-tele-tabby.nvim') > 0 then
  vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope').extensions.tele_tabby.list()<Cr>]], { noremap = true, silent = true })
end
-- find_files
if vim.fn.executable('fd') > 0 then
  telescope.setup {
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
      }
    }
  }
end
vim.api.nvim_set_keymap('n', ',<Tab>', [[<cmd>Telescope find_files<CR>]], { noremap = true, silent = true })
-- notify
if vim.fn['Installed']('nvim-notify') > 0 then
  telescope.load_extension('notify')
  vim.api.nvim_set_keymap('n', ',N', [[<cmd>Telescope notify<CR>]], { noremap = true, silent = true })
end
-- global find functions
_G.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end
_G.search_all = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".grep_string, opts)
  if not ok then require"telescope.builtin".live_grep(opts) end
end
