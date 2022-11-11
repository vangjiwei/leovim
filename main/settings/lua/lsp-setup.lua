local opts = { noremap = true, silent = true }
local map  = vim.api.nvim_set_keymap
--------------------------------
-- lspsaga
--------------------------------
local lspsaga = require('lspsaga')
lspsaga.init_lsp_saga({
  diagnostic_header  = { '😡', '😥', '😤', '😐' },
  code_action_icon   = '💡',
  finder_icons       = { def = '  ', ref = '諭 ', link = '  ' },
  max_preview_lines  = 32,
  finder_action_keys = {
    open   = "<Cr>",
    vsplit = "<C-g>",
    split  = "<C-x>",
    tabe   = "<C-t>",
    quit   = { "<M-q>", "<C-c>", "<ESC>" },
  },
  definition_action_keys = {
    edit   = "<Cr>",
    vsplit = "<C-g>",
    split  = "<C-x>",
    tabe   = "<C-t>",
    quit   = "<M-q>",
  },
  move_in_saga     = { prev = '<C-k>', next = '<C-j>' },
  code_action_keys = {
    quit = { "<M-q>", "<C-c>", "<ESC>" },
    exec = "<Cr>",
  },
  rename_action_quit = "<C-c>",
  show_outline       = {
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
      local ok, saga = pcall(require, 'lspsaga.symbolwinbar')
      local sym
      if ok then sym = saga.get_symbol_node() end
      local win_val = ''
      win_val = get_file_symbol() -- set to true to include path
      if sym ~= nil then win_val = win_val .. sym end
      vim.wo.winbar = win_val
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
-- lsp-setup
require('lsp-setup').setup({
  default_mappings = false,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    local bufmap = vim.api.nvim_buf_set_keymap
    -- Support custom the on_attach function for global
    -- Formatting on save as default
    require('lsp-setup.utils').format_on_save(client)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
  servers = {
    pylsp = {
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
    }
  }
})
-----------------
-- keymaps
-----------------
map('n', '<M-M>', [[<cmd>Mason<CR>]], opts)
-- format
map('n', '<C-q>', [[<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>]], opts)
map('x', '<C-q>', [[<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>]], opts)
-- call hierrachy
map('n', '<M-.>', [[<cmd>lua vim.lsp.buf.incoming_calls()<CR>]], opts)
map('n', '<M-,>', [[<cmd>lua vim.lsp.buf.outgoing_calls()<CR>]], opts)
-- definition type_definition declaration implementation
map('n', '<C-]>', [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
map('n', 'gh', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
map('n', 'gl', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
map('n', 'gm', [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
map('n', '<M-/>', [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
-- lspsaga
map('n', '<F2>', [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<leader>ar', [[<cmd>Lspsaga rename<Cr>]], opts)
map('n', '<C-h>', [[<cmd>Lspsaga hover_doc<Cr>]], opts)
map('n', '<M-:>', [[<cmd>Lspsaga peek_definition<CR>]], opts)
map('n', '<M-;>', [[<cmd>Lspsaga lsp_finder<Cr>]], opts)
map('n', "<leader>a<cr>", [[<cmd>Lspsaga code_action<Cr>]], opts)
map('x', "<leader>a<cr>", [[<cmd>Lspsaga range_code_action<CR>]], opts)
map('n', '<leader>al', [[:Lspsaga ]], { noremap = true, silent = false })
-- Telescope
map('n', 't<Cr>', [[<cmd>Telescope lsp_workspace_symbols<CR>]], opts)
map('n', 'f<Cr>', [[<cmd>Telescope lsp_document_symbols symbols=function,class<CR>]], opts)
map('n', '<leader>t', [[<cmd>Telescope lsp_document_symbols<CR>]], opts)
map('n', 'ZL', [[<cmd>Telescope lsp_dynamic_workspace_symbols<CR>]], opts)
