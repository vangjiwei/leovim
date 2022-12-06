---------------------
-- dap
---------------------
local dap = require("dap")
dap.defaults.fallback.exception_breakpoints = { 'default' }
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
---------------------
-- dapui
---------------------
local dapui = require("dapui")
dapui.setup({
  -- Expand lines larger than the window
  expand_lines = true,
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.7 },
        { id = "watches",     size = 0.1 },
        { id = "stacks",      size = 0.1 },
        { id = "breakpoints", size = 0.1 },
      },
      size = 0.25,
      position = "left",
    },
    {
      elements = {
        "repl";
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = vim.fn.has('nvim-0.8') > 0,
  },
  floating = {
    mappings = {
      close = { "Q", "q", "<Esc>", "<M-q>" },
    },
  },
})
-- auto open/close dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
