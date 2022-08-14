vim.g.symbol_tool  = 'lspsaga-aerial-lsp'
vim.g.symbol_group = nil
local map  = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-----------------
-- mason/lspconfig
-----------------
local mason           = require('mason')
local lspconfig       = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason.setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})
map('n', '<leader>I', [[<cmd>Mason<CR>]], opts)
-- mason_lspconfig
mason_lspconfig.setup({
  automatic_installation = true,
  ensure_installed = vim.g.lsp_installer_servers,
})
mason_lspconfig.setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function (server_name) -- default handler (optional)
    lspconfig[server_name].setup {}
  end,
  -- Next, you can provide targeted overrides for specific servers.
  ["sumneko_lua"] = function ()
    lspconfig.sumneko_lua.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    }
  end,
})
if vim.fn['Installed']('rust-tools.nvim') > 0 then
  local rust_tools = require('rust-tools')
  mason_lspconfig.setup_handlers({
    ["rust_analyzer"] = function ()
      rust_tools.setup({})
    end,
  })
end
--------------------------------
-- telescope
--------------------------------
local telescope = require('telescope')
map('n', 't<Cr>', [[<cmd>Telescope lsp_workspace_symbols<CR>]], opts)
map('n', 'T<Cr>', [[<cmd>Telescope lsp_dynamic_workspace_symbols<CR>]], opts)
map('n', '<M-t>', [[<cmd>Telescope lsp_document_symbols<CR>]], opts)
map('n', 'f<Cr>', [[<cmd>Telescope lsp_document_symbols ignore_symbols=variable<CR>]], opts)
if vim.fn['Installed']('telescope-symbols.nvim') > 0 then
  map('n', 'sy', [[<cmd>Telescope symbols<CR>]], opts)
end
if vim.fn['Installed']('telescope-lsp-handlers.nvim') > 0 then
  telescope.load_extension('lsp_handlers')
  telescope.setup({
    extensions = {
      lsp_handlers = {
        disable = {
          ['textDocument/definition']     = true,
          ['textDocument/implementation'] = true,
        },
      },
    },
  })
end
--------------------------------
-- lspsaga
--------------------------------
local lspsaga = require('lspsaga')
lspsaga.init_lsp_saga({
  diagnostic_header       = { '😡', '😥', '😤', '😐' },
  code_action_icon        = '💡',
  definition_preview_icon = '',
  finder_icons = {
    def = '  ',
    ref = '諭 ',
    link = '  ',
  },
  move_in_saga       = { prev = '<C-k>', next = '<C-j>' },
  max_preview_lines  = 32,
  finder_action_keys = {
    open        = "<Cr>",
    vsplit      = "<C-v>",
    split       = "<C-x>",
    tabe        = "<C-t>",
    quit        = {"<M-q>", "<C-c>", "<ESC>"},
    scroll_down = "<C-d>",
    scroll_up   = "<C-u>",
  },
  code_action_keys = {
    quit = {"<M-q>", "<C-c>", "<ESC>"},
    exec = "<Cr>",
  },
  rename_action_quit = "<C-c>",
  symbol_in_winbar = {
    in_custom = false,
    enable = false,
    separator = ' ',
    show_file = true,
    click_support = false,
  },
  show_outline = {
      win_position = 'left',
      win_width = 40,
      auto_enter = false,
      auto_preview = false,
      virt_text = '┃',
      jump_key = '<Cr>',
      -- auto refresh when change buffer
      auto_refresh = true,
  },
})
-- actions
map('n', '<leader>A', [[:Lspsaga ]], { noremap = true, silent = false })
map('n', 'K', [[<cmd>Lspsaga hover_doc<Cr>]], opts)
map('n', "<leader>a<cr>", [[<cmd>Lspsaga code_action<Cr>]], opts)
map('x', "<leader>a<cr>", [[:<C-u>Lspsaga range_code_action<CR>]], opts)
map('n', '<leader>ar', [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<C-h>', [[<cmd>Lspsaga signature_help<Cr>]], opts)
map('n', '<BS>', [[<cmd>Lspsaga signature_help<Cr>]], opts)
map('n', '<C-j>', [[<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1,  '%')<Cr>]], opts)
map('n', '<C-k>', [[<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, 'g%')<Cr>]], opts)
-- Show symbols in winbar need neovim 0.8+
if vim.fn.has('nvim-0.8') > 0 then
  lspsaga.init_lsp_saga({
    symbol_in_winbar = {
      in_custom = true,
      click_support = function(node, clicks, button, modifiers)
        -- To see all avaiable details: vim.pretty_print(node)
        local st = node.range.start
        local en = node.range['end']
        if button == "l" then
          if clicks == 2 then
            -- double left click to do nothing
          else -- jump to node's starting line+char
            vim.fn.cursor(st.line + 1, st.character + 1)
          end
        elseif button == "r" then
          if modifiers == "s" then
            print "lspsaga" -- shift right click to print "lspsaga"
          end -- jump to node's ending line+char
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == "m" then
          -- middle click to visual select node
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd "normal v"
          vim.fn.cursor(en.line + 1, en.character + 1)
        end
      end
    }
  })
  local function get_file_name(include_path)
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    if include_path == false then return file_name end
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local path_list = vim.split(vim.fn.expand '%:~:.:h', sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
      file_path = (cur == '.' or cur == '~') and '' or
      file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
  end

  local function config_winbar()
    local ok, symbolwinbar = pcall(require, 'lspsaga.symbolwinbar')
    local sym
    if ok then sym = symbolwinbar.get_symbol_node() end
    local win_val = ''
    win_val = get_file_name(false) -- set to true to include path
    if sym ~= nil then win_val = win_val .. sym end
    vim.wo.winbar = win_val
  end

  local events = { 'CursorHold', 'BufEnter', 'BufWinEnter', 'CursorMoved', 'WinLeave', 'User LspasgaUpdateSymbol' }

  local exclude = {
    ['teminal'] = true,
    ['prompt'] = true
  }

  vim.api.nvim_create_autocmd(events, {
    pattern = '*',
    callback = function()
      -- Ignore float windows and exclude filetype
      if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
        vim.wo.winbar = ''
      else
        config_winbar()
      end
    end,
  })

end
--------------------------------
-- lint settings
--------------------------------
map('n', '[d', [[<cmd>Lspsaga diagnostic_jump_prev<Cr>]], opts)
map('n', ']d', [[<cmd>Lspsaga diagnostic_jump_next<Cr>]], opts)
map('n', '<leader>al', [[<cmd>Lspsaga show_line_diagnostics<Cr>]], opts)
map('n', '<leader>ad', [[<cmd>Lspsaga show_cursor_diagnostics<Cr>]], opts)
-- toggle diagnostic
vim.g.diagnostics_enable = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_enable then
    print("diagnostics off")
    vim.g.diagnostics_enable = false
    vim.diagnostic.disable()
    -- vim.diagnostic.config({
    --   virtual_text = false
    -- })
  else
    print("diagnostics on")
    vim.g.diagnostics_enable = true
    vim.diagnostic.enable()
    -- vim.diagnostic.config({
    --   virtual_text = true
    -- })
  end
end
vim.api.nvim_set_keymap('n', '<Leader>d', [[<cmd>lua toggle_diagnostics()<Cr>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>D', [[<cmd>Telescope diagnostics<Cr>]], opts)
-- toggle diagnostic virtual text
vim.g.diagnostics_virtualtext = true
function _G.toggle_diagnostics_virtualtext()
  if vim.g.diagnostics_virtualtext then
    print("virtual_text off")
    vim.g.diagnostics_virtualtext = false
    vim.diagnostic.config({
      virtual_text = false,
      underline = true,
    })
  else
    print("virtual_text on")
    vim.g.diagnostics_virtualtext = true
    vim.diagnostic.config({
      virtual_text = true,
      underline = false,
    })
  end
end
vim.api.nvim_set_keymap('n', '<M-">', [[<cmd>lua toggle_diagnostics_virtualtext()<Cr>]], {silent = true, noremap = true})
--------------------------------
-- lsp-handlers
--------------------------------
-- format
map('n', '<C-q>', [[<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>]], opts)
map('x', '<C-q>', [[<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>]], opts)
-- call hierrachy
map('n', '<leader>i', [[<cmd>lua vim.lsp.buf.incoming_calls()<CR>]], opts)
map('n', '<leader>o', [[<cmd>lua vim.lsp.buf.outgoing_calls()<CR>]], opts)
-- definition and reference
map('n', '<C-]>', [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
map('n', '<M-;>', [[<cmd>Lspsaga lsp_finder<Cr>]], opts)
map('n', '<M-:>', [[<cmd>Lspsaga implement<Cr>]], opts)
map('n', '<M-/>', [[<cmd>Lspsaga preview_definition<CR>]], opts)
-- TODO: use lspsaga declaration, type_definition
map('n', '<M-,>', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
map('n', '<M-.>', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
