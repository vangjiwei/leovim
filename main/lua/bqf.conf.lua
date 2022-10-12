require('bqf').setup({
  auto_enable = true,
  auto_resize_height = true, -- highly recommended enable
  preview = {
    auto_preview = true,
    win_height = 12,
    win_vheight = 12,
    delay_syntax = 80,
    border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
    should_preview_cb = function(bufnr)
      local ret = true
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local fsize = vim.fn.getfsize(bufname)
      if fsize > 100 * 1024 then
        -- skip file size greater than 100k
        ret = false
      elseif bufname:match('^fugitive://') then
        -- skip fugitive buffer
        ret = false
      end
      return ret
    end
  },
  func_map = {
    pscrollup   = '<C-k>',
    pscrolldown = '<C-j>',
    ptogglemode = '<M-o>',
    vsplit      = '<C-h>',
    openc = 'e',
    drop  = 'E',
  },
})

