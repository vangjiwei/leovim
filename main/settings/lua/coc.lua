-- TODO: config coc.nvim when nvim-0.8+
function _G.symbol_line()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
  local ok, line = pcall(vim.api.nvim_buf_get_var, bufnr, 'coc_symbol_line')
  return ok and '%#CocSymbolLine# ' .. line or ''
end

vim.api.nvim_create_autocmd(
  { 'CursorHold', 'WinEnter', 'BufWinEnter' },
  {
    pattern = "*",
    callback = function()
      if vim.b.coc_symbol_line and vim.bo.buftype == '' and vim.opt_local.winbar:get() == '' then
        vim.opt_local.winbar = '%!v:lua.symbol_line()'
      else
        vim.opt_local.winbar = ''
      end
    end,
  }
)
