local mappings = require('plugin.mappings')

local M = {}

function M.cmp()
  local is_cmp, cmp = pcall(require, 'cmp')

  if not (is_cmp) then
    return
  end

  local is_luasnip, luasnip = pcall(require, 'luasnip')
  local function luasnip_structure()
    if is_luasnip then
      return { name = "luasnip" }
    end
  end

  local is_cmp_npm, cmp_npm = pcall(require, 'cmp-npm')
  local function cmp_npm_structure()
    if is_cmp_npm then
      cmp_npm.setup({})
      return { name = "npm", keyword_length = 4 }
    end
  end

  local kind_icons = {
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
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      documentation = cmp.config.window.bordered()
    },
    mapping = mappings.nvim_cmp(cmp),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
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
      luasnip_structure(),
      { name = "buffer" },
      { name = "path" },
      cmp_npm_structure(),
      { name = "nvim_lua" },
    },
  })
end

function M.cmp_nvim_lsp()
  return pcall(require, 'cmp_nvim_lsp')
end

return M
