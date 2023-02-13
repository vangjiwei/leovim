local opts = { noremap = true, silent = true }
local map  = vim.api.nvim_set_keymap
-----------------
-- mason
-----------------
require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require('mason-lspconfig').setup({
  automatic_installation = true,
  ensure_installed = vim.g.lsp_installer_servers,
})
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set('n', '<M-/>', vim.lsp.buf.references, { buffer = bufnr })
  vim.keymap.set('n', '<M-?>', vim.lsp.buf.implementation, { buffer = bufnr })
  vim.keymap.set('n', 'gh', vim.lsp.buf.type_definition, { buffer = bufnr })
  vim.keymap.set('n', 'gm', vim.lsp.buf.declaration, { buffer = bufnr })
  -- format
  vim.keymap.set('n', '<C-q>', vim.lsp.buf.format, { buffer = bufnr })
  if vim.fn.has('nvim-0.8.2') > 0 then
    vim.keymap.set('x', '<C-q>', vim.lsp.buf.format, { buffer = bufnr })
  else
    vim.keymap.set('x', '<C-q>', vim.lsp.buf.range_formatting, { buffer = bufnr })
  end
  -- call hierrachy
  vim.keymap.set('n', '<M-.>', vim.lsp.buf.incoming_calls, { buffer = bufnr })
  vim.keymap.set('n', '<M-,>', vim.lsp.buf.outgoing_calls, { buffer = bufnr })
end
local get_servers = require('mason-lspconfig').get_installed_servers
for _, server_name in ipairs(get_servers()) do
  lspconfig[server_name].setup({
    on_attach = lsp_attach,
    capabilities = lsp_capabilities
  })
end
-----------------
-- keymaps
-----------------
-- Mason
map('n', ',m', [[<cmd>Mason<CR>]], opts)
-- Telescope symbols
map('n', '<leader>o', [[<cmd>Telescope lsp_document_symbols<CR>]], opts)
map('n', 'f<Cr>', [[<cmd>Telescope lsp_document_symbols symbols=function,class,method<CR>]], opts)
map('n', 'F<Cr>', [[<cmd>Telescope lsp_workspace_symbols symbols=function,class,method<CR>]], opts)
map('n', 'T<Cr>', [[<cmd>Telescope lsp_workspace_symbols<CR>]], opts)
if Installed('nvim-treesitter') then
  map('n', 't<Cr>', [[<cmd>Telescope treesitter<CR>]], opts)
end
--------------------------------
-- lspsaga
--------------------------------
local lspsaga = require('lspsaga')
lspsaga.setup({
  ui = {
    border = 'single'
  },
  symbol_in_winbar = {
    folder_level = 1,
  },
  lightbulb = {
    virtual_text = false,
  },
  scroll_preview = {
    scroll_down = '<C-j>',
    scroll_up = '<C-k>',
  },
  finder = {
    edit   = { "e", "<Cr>" },
    vsplit = "i",
    split  = "s",
    tabe   = "t",
    quit   = { "<ESC>", "<C-c>", "q" },
  },
  definition = {
    edit   = "<Cr>",
    vsplit = "i",
    split  = "s",
    tabe   = "t",
    close  = "<Esc>",
    quit   = "q",
  },
  code_action = {
    kesy = {
      quit = "q",
      exec = "<Cr>",
    }
  },
  diagnostic = {
    twice_into = false,
    show_code_action = true,
    show_source = true,
    keys = {
      exec_action = "<Cr>",
      go_action = "g",
      quit = "q",
    },
  },
  outline = {
    win_position = 'left',
    win_width = 30,
    auto_refresh = true,
    keys = {
      jump = "<Cr>",
      expand_collapse = "o",
      quit = "q",
    }
  },
  rename = {
    quit = "<C-c>",
    exec = "<Cr>",
    in_select = true,
  },
  callhierarchy = {
    show_detail = false,
    keys = {
      edit            = "<Cr>",
      vsplit          = "i",
      split           = "s",
      tabe            = "t",
      quit            = "q",
      jump            = "g",
      expand_collapse = "o",
    },
  },
})
-- Show symbols in winbar need neovim 0.8+
vim.wo.winbar = require('lspsaga.symbolwinbar'):get_winbar()
-- lspsaga maps
map('n', 'K', [[<Cmd>Lspsaga hover_doc<Cr>]], opts)
map('n', '<leader>ar', [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<F2>', [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<M-;>', [[<cmd>Lspsaga lsp_finder<Cr>]], opts)
map('n', '<M-:>', [[<cmd>Lspsaga peek_definition<CR>]], opts)
map('n', "<leader>a<cr>", [[<cmd>Lspsaga code_action<Cr>]], opts)
map('x', "<leader>a<cr>", [[<cmd>Lspsaga range_code_action<CR>]], opts)
map('n', '<leader>al', [[:Lspsaga]], { noremap = true, silent = false })
