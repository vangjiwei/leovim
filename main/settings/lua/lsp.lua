local opts = { noremap = true, silent = true }
local map  = vim.api.nvim_set_keymap
-----------------
-- mason/lspconfig/lspsetup
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
local lsp_attach = function(_, bufnr)
  -- definition type_definition declaration implementation
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {buffer=bufnr})
  vim.keymap.set('n', '<M-/>', vim.lsp.buf.references, {buffer=bufnr})
  vim.keymap.set('n', 'gh', vim.lsp.buf.type_definition, {buffer=bufnr})
  vim.keymap.set('n', 'gl', vim.lsp.buf.declaration, {buffer=bufnr})
  vim.keymap.set('n', 'gm', vim.lsp.buf.implementation, {buffer=bufnr})
  -- format
  vim.keymap.set('n', '<C-q>', vim.lsp.buf.format, {buffer=bufnr})
  vim.keymap.set('x', '<C-q>', vim.lsp.buf.range_formatting, {buffer=bufnr})
  -- call hierrachy
  vim.keymap.set('n', '<M-.>', vim.lsp.buf.incoming_calls, {buffer=bufnr})
  vim.keymap.set('n', '<M-,>', vim.lsp.buf.outgoing_calls, {buffer=bufnr})
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
map('n', '<M-M>', [[<cmd>Mason<CR>]], opts)
-- Telescope symbols
map('n', '<leader>t', [[<cmd>Telescope lsp_document_symbols<CR>]], opts)
map('n', 'f<Cr>',     [[<cmd>Telescope lsp_document_symbols symbols=function,class<CR>]], opts)
map('n', 'T<Cr>', [[<cmd>Telescope lsp_workspace_symbols<CR>]], opts)
map('n', 't<Cr>', [[<cmd>Telescope lsp_dynamic_workspace_symbols<CR>]], opts)
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
    edit   = {"e", "<Cr>"},
    vsplit = "g",
    split  = "s",
    tabe   = "t",
    quit   = {"<ESC>", "<C-c>", "q"},
  },
  definition = {
    edit   = "<Cr>",
    vsplit = "<C-g>",
    split  = "<C-x>",
    tabe   = "<C-t>",
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
      edit   = "e",
      vsplit = "g",
      split  = "s",
      tabe   = "t",
      quit   = "q",
      jump   = "<Cr>",
      expand_collapse = "o",
    },
  },
})
-- Show symbols in winbar need neovim 0.8+
if vim.fn.has('nvim-0.8') > 0 then
  vim.wo.winbar = require('lspsaga.symbolwinbar'):get_winbar()
end
-- lspsaga maps
map('n', '<leader>ar', [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<F2>',  [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<C-h>', [[<cmd>Lspsaga hover_doc<Cr>]], opts)
map('n', '<M-;>', [[<cmd>Lspsaga lsp_finder<Cr>]], opts)
map('n', '<M-:>', [[<cmd>Lspsaga peek_definition<CR>]], opts)
map('n', "<leader>a<cr>", [[<cmd>Lspsaga code_action<Cr>]], opts)
map('x', "<leader>a<cr>", [[<cmd>Lspsaga range_code_action<CR>]], opts)
map('n', '<leader>al', [[:Lspsaga]], {noremap = true, silent = false })
