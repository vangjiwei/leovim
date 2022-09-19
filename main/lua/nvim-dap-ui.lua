---------------------
-- dap
---------------------
local dapui = require("dapui")
if vim.g.leovim_loaded == 0 then
  dapui.setup({
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open   = "o",
      remove = "d",
      edit   = "e",
      repl   = "r",
      toggle = "t",
    },
    expand_lines = vim.fn.has("nvim-0.7"),
    windows = {
      sidebar = {
        elements = {
          { id = "scopes", size = 0.50 },
          { id = "watches", size = 0.20 },
          { id = "stacks", size = 0.20 },
          { id = "breakpoints", size = 0.10 },
        }
      },
      floating = {
        mappings = {
          close = { "q", "<Esc>", "<M-q>" },
        },
      }
    },
  })
end
---------------------
-- dap
---------------------
local dap = require("dap")
dap.defaults.fallback.exception_breakpoints = { 'raised' }
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
-- 如果开启或关闭调试，则自动打开或关闭调试界面
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
  dap.repl.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
  dap.repl.close()
end
dap.listeners.after.event_initialized["dapui_config"] = function()
  local f, _ = pcall(dapui.open)
  if f then
    print('dapui opened')
  else
    print('dapui is already opened')
  end
end
if installed('nvim-dap-virtual-text') then
  local dap_virtual_text = require('nvim-dap-virtual-text')
  vim.g.dap_virtualtext = true
  dap_virtual_text.setup {
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
    all_references = false, -- show virtual text on all all references of the variable (not only definitions)
    filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
    -- experimental features:
    virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
  }
  dap.listeners.after.exceptionInfo['nvim-dap-virtual-text'] = function() end
  function _G.toggle_dap_virtualtext()
    if vim.g.dap_virtualtext then
      print("dap_virtualtext off")
      vim.g.dap_virtualtext = false
      vim.diagnostic.config({
        enabled = false
      })
    else
      print("dap_virtualtext on")
      vim.g.dap_virtualtext = true
      vim.diagnostic.config({
        enabled = true
      })
    end
  end

  vim.api.nvim_set_keymap('n', '<M-">', [[<cmd>lua toggle_dap_virtualtext()<Cr>]], { silent = true, noremap = true })
end
