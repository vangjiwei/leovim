local function symbol_line()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
  local ok, line = pcall(vim.api.nvim_buf_get_var, bufnr, 'coc_symbol_line')
  return ok and line or ''
end

if vim.fn.exists '&winbar' then
  vim.api.nvim_create_autocmd( { 'CursorMoved', 'WinEnter', 'BufWinEnter' }, {
    pattern = '*',
    callback = function()
      if vim.b.coc_symbol_line and vim.bo.buftype == '' then
        if vim.opt_local.winbar:get() == '' then
          local winvar = symbol_line()
          vim.wo.winbar = winvar
        end
      else
        vim.wo.winbar = ''
      end
    end,
  })
end
