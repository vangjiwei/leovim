---------------------
-- dapui
-- NOTE: dapui must be setup before dap
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
-- function to get adaptor
---------------------
local function get_adaptor(adaptor)
  if WINDOWS() then
    return vim.fn.expand("$HOME/AppData/Local/nvim-data/mason/bin/") .. adaptor .. ".cmd"
  elseif UNIX() then
    return vim.fn.expand("$HOME/.local/share/nvim/mason/bin/") .. adaptor
  else
    return nil
  end
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
