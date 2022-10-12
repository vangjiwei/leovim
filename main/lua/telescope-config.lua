local map           = vim.api.nvim_set_keymap
local opts          = { noremap = true, silent = true }
local telescope     = require('telescope')
local actions       = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
-- fzf core
if Installed('telescope-fzf-native.nvim') then
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
-- find_files
if executable('fd') then
  telescope.setup {
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
      }
    }
  }
end
-- keymaps
map('n', ',<Tab>', [[<cmd>Telescope find_files<CR>]], opts)
map('n', '<M-l>f', [[<cmd>Telescope current_buffer_fuzzy_find<Cr>]], opts)
-- extensions
if Installed('telescope-changes.nvim') then
  telescope.load_extension('changes')
  map('n', '<M-y>', [[<cmd>Telescope changes<CR>]], opts)
end
if Installed('telescope-ultisnips.nvim') then
  telescope.load_extension('ultisnips')
  map('i', '<C-x><C-x>', [[<ESC><cmd>Telescope ultisnips<CR>]], opts)
elseif Installed('telescope-luasnip.nvim') then
  telescope.load_extension('luasnip')
  map('i', '<C-x><C-x>', [[<ESC><cmd>Telescope luasnip<CR>]], opts)
end
if Installed('telescope-floaterm.nvim') then
  telescope.load_extension('floaterm')
  map('n', '<leader>w', [[<cmd>Telescope floaterm<CR>]], opts)
end
if Installed('telescope-ui-select.nvim') then
  telescope.load_extension("ui-select")
end
if Installed('telescope-buffer-lines.nvim') then
  telescope.load_extension('buffer_lines')
  map('i', '<C-x><C-l>', [[<ESC><cmd>Telescope buffer_lines<CR>]], opts)
end
if Installed('telescope-tele-tabby.nvim') then
  map('n', '<leader>t', [[<cmd>lua require('telescope').extensions.tele_tabby.list()<Cr>]], opts)
end
if Installed('nvim-notify') then
  telescope.load_extension('notify')
  map('n', ',N', [[<cmd>Telescope notify<CR>]], opts)
end
-- project_files
_G.project_files = function()
  local search_opts = {}
  local ok = pcall(require "telescope.builtin".git_files, search_opts)
  if not ok then require "telescope.builtin".find_files(search_opts) end
end
_G.search_all = function()
  local ok = pcall(require"telescope.builtin".grep_string, {})
  if not ok then require"telescope.builtin".live_grep({}) end
end
