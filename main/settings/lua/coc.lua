if vim.fn.exists '&winbar' then
  vim.api.nvim_create_autocmd( { 'CursorMoved', 'WinEnter', 'BufWinEnter' }, {
    pattern = '*',
    callback = function()
      if vim.b.vista_nearest_method_or_function and vim.bo.buftype == '' and vim.opt_local.winbar:get() == '' then
          vim.wo.winbar = vim.b.vista_nearest_method_or_function
      else
        vim.wo.winbar = ''
      end
    end,
  })
end
