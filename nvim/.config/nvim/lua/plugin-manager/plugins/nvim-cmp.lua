return {
  -- completion
  'hrsh7th/nvim-cmp',
  dependencies = {
    "hrsh7th/cmp-buffer",
    --"hrsh7th/cmp-path",
    --"hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip", -- snippet engine
    "saadparwaiz1/cmp_luasnip",
    --"rafamadriz/friendly-snippets",
    --"onsails/lspkind.nvim",
    'David-Kunz/cmp-npm',
    'hrsh7th/cmp-nvim-lua', -- lua vim.lsp.* API completion
  },
  event = "InsertEnter",
  opts = {
    kind_icons = {
      Text = "",
      Method = "m",
      Function = "",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    }
  },
  config = function(_, opts)
    local is_cmp, cmp = pcall(require, 'cmp')
    if not (is_cmp) then
      print('nvim-cmp is not installed')
      return
    end

    cmp.setup({
      snippet = opts.snippet,
      window = {
        documentation = cmp.config.window.bordered()
      },
      mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s", opts.kind_icons[vim_item.kind])

          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "npm",     keyword_length = 4 },
        { name = "nvim_lua" },
      },
    })
  end
}
