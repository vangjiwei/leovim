-----------------
-- cmp config
-----------------
local fn = vim.fn
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
-- sources
if Installed('friendly-snippets') then
  require("luasnip.loaders.from_vscode").lazy_load()
end
local sources = {
  { name = 'luasnip' },
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'nvim_lua' },
  { name = 'buffer' },
  { name = 'path' },
}
-- core setup
local MAX_LABEL_WIDTH = 32
local ELLIPSIS_CHAR = '...'
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local get_ws = function(max, len)
  return (" "):rep(max - len)
end
cmp.setup({
  sources = cmp.config.sources(sources),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping({
    ["<S-Tab>"] = {
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end
    },
    ['<C-n>'] = {
      c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end
    },
    ['<C-p>'] = {
      c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end
    },
    ['<C-e>'] = {
      c = cmp.mapping.abort(),
      i = function(fallback)
        if cmp.visible() then
          cmp.abort()
        else
         -- how to input  <C-o>A
          fallback()
        end
      end
    },
    ['<C-y>'] = {
      c = cmp.mapping.confirm({
        select = false,
      }),
      i = function(fallback)
        if cmp.visible() then
          cmp.close()
        elseif fn.pumvisible() > 0 then
          fallback()
        else
          fn.feedkeys(fn.getreg('"'))
        end
      end
    },
    ['<Cr>'] = {
      c = function(fallback)
        fallback()
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.close()
        else
          fallback()
        end
      end
    },
    ['<Tab>'] = {
      i = function(fallback)
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if entry then
            cmp.confirm()
          else
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          end
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      c = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      s = function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
    }
  }),
  -- 使用lspkind-nvim显示类型图标
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      with_text = true,
      maxwidth = MAX_LABEL_WIDTH,
      ellipsis_char = ELLIPSIS_CHAR,
      before = function(entry, item)
        -- Source 显示提示来源
        local content = item.abbr
        if #content > MAX_LABEL_WIDTH then
          item.abbr = fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
        else
          item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
        end
        item.menu = "[" .. string.upper(entry.source.name) .. "]"
        return item
      end
    })
  }
})
----------------------------------
-- Use buffer source for `/`.
----------------------------------
cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'buffer' }
  }, {
    { name = 'nvim_lsp_document_symbol' }
  })
})
----------------------------------
-- Use cmdline & path source for ':'
----------------------------------
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
----------------------------------
-- gitcommit
----------------------------------
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were Installed it.
    { name = 'buffer' },
  })
})
---------------------------
-- autopairs
---------------------------
if Installed('nvim-autopairs') then
  local autopairs = require("nvim-autopairs")
  autopairs.setup({
    disable_filetype = { "TelescopePrompt" },
  })
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
  )
  if Installed('nvim-treesitter') then
    autopairs.setup({
      -- treesitter
      check_ts = true,
      ts_config = {
        lua = { 'string' }, -- it will not add a pair on that treesitter node
        javascript = { 'template_string' },
        java = false, -- don't check treesitter on java
      }
    })
    -- press % => %% only while inside a comment or string
    local ts_conds = require('nvim-autopairs.ts-conds')
    local Rule = require('nvim-autopairs.rule')
    autopairs.add_rules({
      Rule("%", "%", "lua")
      :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
      Rule("$", "$", "lua")
      :with_pair(ts_conds.is_not_ts_node({ 'function' }))
    })
  end
end
