-----------------
-- cmp config
-----------------
local cmp = require('cmp')
local lspkind = require('lspkind')
-- snippets
local snippets = { { name = 'nvim_lsp' }, { name = 'nvim_lua' } }
local snippets_opts = {}
if Installed('ultisnips') then
  table.insert(snippets, { name = 'ultisnips' })
  snippets_opts = {
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end
    }
  }
elseif Installed('luasnip') then
  table.insert(snippets, { name = 'luasnip' })
  if Installed('friendly-snippets') then
    require("luasnip.loaders.from_vscode").lazy_load()
  end
  snippets_opts = {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    }
  }
end
-- core setup
local cmp_opts = {
  sources = cmp.config.sources(snippets, {
    { name = 'omni' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = {
      c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    },
    ['<C-p>'] = {
      c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    ['<C-e>'] = {
      c = cmp.mapping.close(),
      i = cmp.mapping.abort(),
    },
    ['<C-y>'] = {
      c = cmp.mapping.complete(),
      i = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      })
    },
    ["<S-Tab>"] = cmp.mapping({
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
    }),
    ['<Tab>'] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end,
      i = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      })
    }),
    ['<Cr>'] = {
      c = cmp.mapping.confirm({
        select = false,
      }),
      i = cmp.mapping.abort(),
    },
  }),
  -- 使用lspkind-nvim显示类型图标
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      before = function(entry, vim_item)
        -- Source 显示提示来源
        vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
        return vim_item
      end
    })
  }
}
for k, v in pairs(snippets_opts) do cmp_opts[k] = v end
cmp.setup(
  cmp_opts
)
-- Use buffer source for `/`.
require 'cmp'.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
-- gitcommit
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
