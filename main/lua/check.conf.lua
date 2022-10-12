local map  = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
function _G.LspsagaJumpError(direction)
  if direction > 0 then
    require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
  else
    require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end
end
map('n', '[e', [[<cmd>lua LspsagaJumpError(0)<Cr>]], opts)
map('n', ']e', [[<cmd>lua LspsagaJumpError(1)<Cr>]], opts)
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
  else
    print("diagnostics on")
    vim.g.diagnostics_enable = true
    vim.diagnostic.enable()
  end
end
map('n', '<Leader>d', [[<cmd>lua toggle_diagnostics()<Cr>]], opts)
map('n', '<Leader>D', [[<cmd>Telescope diagnostics<Cr>]], opts)
-- toggle diagnostic virtual text && underline
function _G.toggle_diagnostics_virtualtext()
  if vim.g.diagnostic_virtualtext_underline then
    print("virtual_text off")
    vim.g.diagnostic_virtualtext_underline = false
    vim.diagnostic.config({
      virtual_text = false,
      underline = false,
    })
  else
    print("virtual_text on")
    vim.g.diagnostic_virtualtext_underline = true
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
    })
  end
end
vim.g.diagnostic_virtualtext_underline = false
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
})
map('n', '<M-">', [[<cmd>lua toggle_diagnostics_virtualtext()<Cr>]], {silent = true, noremap = true})

