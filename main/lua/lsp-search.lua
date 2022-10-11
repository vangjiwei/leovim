vim.g.symbol_tool  = 'lspsaga-lsp'
vim.g.symbol_group = nil
local map          = vim.api.nvim_set_keymap
local opts         = { noremap = true, silent = true }
--------------------------------
-- telescope
--------------------------------
local telescope    = require('telescope')
if Installed('telescope-lsp-handlers.nvim') then
  telescope.load_extension('lsp_handlers')
  telescope.setup({})
end
--------------------------------
-- lspsaga
--------------------------------
local lspsaga = require('lspsaga')
lspsaga.init_lsp_saga({
  diagnostic_header      = { '😡', '😥', '😤', '😐' },
  code_action_icon       = '💡',
  finder_icons           = { def = '  ', ref = '諭 ', link = '  ' },
  max_preview_lines      = 32,
  finder_action_keys     = {
    open   = "<Cr>",
    vsplit = "<C-v>",
    split  = "<C-x>",
    tabe   = "<C-t>",
    quit   = { "<M-q>", "<C-c>", "<ESC>" },
  },
  definition_action_keys = {
    edit   = '<Cr>',
    vsplit = '<C-v>',
    split  = '<C-x>',
    tabe   = '<C-t>',
    quit   = '<M-q>',
  },
  move_in_saga     = { prev = '<C-k>', next = '<C-j>' },
  code_action_keys = {
    quit = { "<M-q>", "<C-c>", "<ESC>" },
    exec = "<Cr>",
  },
  rename_action_quit = "<C-c>",
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

  local function get_file_symbol()
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
      file_path = (cur == '.' or cur == '~') and '' or
      file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
  end

  local function config_winbar_or_statusline()
    local exclude = {
      ['terminal'] = true,
      ['toggleterm'] = true,
      ['prompt'] = true,
      ['NvimTree'] = true,
      ['help'] = true,
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
      vim.wo.winbar = ''
    else
      local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
      local sym
      if ok then sym = lspsaga.get_symbol_node() end
      local win_val = ''
      win_val = get_file_symbol() -- set to true to include path
      if sym ~= nil then win_val = win_val .. sym end
      vim.wo.winbar = win_val
      -- if work in statusline
      -- vim.wo.stl = win_val
    end
  end

  local events = { 'BufEnter', 'BufWinEnter', 'CursorMoved' }

  vim.api.nvim_create_autocmd(events, {
    pattern = '*',
    callback = function() config_winbar_or_statusline() end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = function() config_winbar_or_statusline() end,
  })

end
-----------------
-- on attach
-----------------
-- format
map('n', '<C-q>', [[<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>]], opts)
map('x', '<C-q>', [[<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>]], opts)
-- call hierrachy
map('n', '<M-,>', [[<cmd>lua vim.lsp.buf.incoming_calls()<CR>]], opts)
map('n', '<M-.>', [[<cmd>lua vim.lsp.buf.outgoing_calls()<CR>]], opts)
-- definition type_definition declaration implementation
map('n', '<C-]>', [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
map('n', '<gh>',  [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
map('n', '<gl>',  [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
map('n', '<gm>',  [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
map('n', 't<Cr>', [[<cmd>Telescope lsp_workspace_symbols<CR>]], opts)
map('n', 'T<Cr>', [[<cmd>Telescope lsp_dynamic_workspace_symbols<CR>]], opts)
map('n', '<M-t>', [[<cmd>Telescope lsp_document_symbols<CR>]], opts)
map('n', 'f<Cr>', [[<cmd>Telescope lsp_document_symbols symbols=function,class<CR>]], opts)
map('n', '<M-/>', [[:TeleSearchAll <C-r><C-w><CR>]], {noremap = false, silent = true})
map('n', '<M-?>', [[:GrepperSearchAll <C-r><C-w><CR>]], {noremap = false, silent = true})
-- lspsaga maps
map('n', 'K', [[<cmd>Lspsaga hover_doc<Cr>]], opts)
map('n', '<M-;>', [[<cmd>Lspsaga lsp_finder<Cr>]], opts)
map('n', '<M-:>', [[<cmd>Lspsaga peek_definition<CR>]], opts)
map('n', "<leader>a<cr>", [[<cmd>Lspsaga  code_action<Cr>]], opts)
map('x', "<leader>a<cr>", [[:<C-u>Lspsaga range_code_action<CR>]], opts)
map('n', '<leader>ar', [[<cmd>Lspsaga  rename<Cr>]], opts)
map('n', '<leader>A', [[:Lspsaga]], { noremap = true, silent = false })
--------------------------------
-- each lsp server config
--------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly     = true
}
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
map('n', '<leader>P', [[<cmd>Mason<CR>]], opts)
-- mason_lspconfig
mason_lspconfig.setup({
  automatic_installation = true,
  ensure_installed = vim.g.lsp_installer_servers,
})
mason_lspconfig.setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each Installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    lspconfig[server_name].setup {
      capabilities = capabilities
    }
  end,
  -- Next, you can provide targeted overrides for specific servers.
  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim", "lua" }
          }
        }
      }
    }
  end,
})
if Installed('rust-tools.nvim') then
  local rust_tools = require('rust-tools')
  mason_lspconfig.setup_handlers({
    ["rust_analyzer"] = function()
      rust_tools.setup({})
    end,
  })
end
if executable('pylsp') then
  local pylsp_args = { '--max-line-length=160', '--ignore=' .. vim.g.python_lint_ignore }
  lspconfig.pylsp.setup({
    settings = {
      pylsp = {
        plugins = {
          pylint = { enabled = true, executable = 'pylint', args = pylsp_args },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          jedi_completion = { fuzzy = false },
          pyls_isort = { enabled = false },
          pyls_flake8 = { enabled = true, executable = 'flake8', args = pylsp_args },
          pylrp_mypy = { enabled = false },
        },
      },
    },
    flags = {
      debounce_text_changes = 200,
    },
  })
end
-----------------
-- ufo
-----------------
if Installed('nvim-ufo') and Installed('promise-async') then
  require('ufo').setup()
end
