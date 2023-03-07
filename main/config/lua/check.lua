local map  = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
function _G.LspsagaJumpError(direction)
  if direction > 0 then
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  else
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end
end
map('n', '[e', [[<cmd>lua LspsagaJumpError(0)<Cr>]], opts)
map('n', ']e', [[<cmd>lua LspsagaJumpError(1)<Cr>]], opts)
map('n', '[d', [[<cmd>Lspsaga diagnostic_jump_prev<Cr>]], opts)
map('n', ']d', [[<cmd>Lspsaga diagnostic_jump_next<Cr>]], opts)
map('n', '<M-h>d', [[<cmd>Lspsaga show_cursor_diagnostics<Cr>]], opts)
map('n', '<M-h>l', [[<cmd>Lspsaga show_line_diagnostics<Cr>]], opts)
-- toggle diagnostic
vim.g.diagnostics_enable = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_enable then
    print("diagnostics off")
    vim.g.diagnostics_enable = false
    vim.diagnostic.disable()
  else
    print("diagnostics on")
    vim.g.diagnostics_enable = true
    vim.diagnostic.enable()
  end
end
map('n', '<Leader>t', [[<cmd>lua toggle_diagnostics()<Cr>]], opts)
map('n', '<Leader>l', [[<cmd>Telescope diagnostics<Cr>]], opts)
-- toggle diagnostic virtual text && underline
function _G.toggle_diagnostics_hightlights()
  if vim.g.diagnostic_virtualtext_underline then
    print("virtualtext_underline off")
    vim.g.diagnostic_virtualtext_underline = false
    vim.diagnostic.config({
      virtual_text = false,
      underline = false,
    })
  else
    print("virtualtext_underline on")
    vim.g.diagnostic_virtualtext_underline = true
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
    })
  end
end
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
})
map('n', "<leader>L", [[<cmd>lua toggle_diagnostics_hightlights()<Cr>]], {silent = true, noremap = true})
