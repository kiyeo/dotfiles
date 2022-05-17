local mappings = require('plugin.mappings')

local is_colorscheme, colorscheme_plugin = pcall(require, 'onenord')
if is_colorscheme then
  colorscheme_plugin.setup {
    custom_highlights = {
      BufferLineIndicatorSelected = { fg = "#88c0d0", bg = "#2e3440" },
      BufferLineFill = { fg = "#ECEFF4", bg = "#242932" },
      GitSignsChange = { fg = '#d08770' },
      GitSignsChangeNr = { fg = '#d08770' },
      GitSignsChangeLn = { fg = '#d08770' }
    }
  }
end

local is_lualine, lualine = pcall(require, 'lualine')
if is_lualine then
  lualine.setup()
end

local is_cmp, cmp = pcall(require, 'cmp')
local is_luasnip, luasnip = pcall(require, 'luasnip')
if is_cmp and is_luasnip then
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

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      documentation = cmp.config.window.bordered()
    },
    mapping = mappings.nvim_cmp(),
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
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },
  }
end

local installed_languages = {}
local is_nvim_lsp_installer, nvim_lsp_installer = pcall(require, 'nvim-lsp-installer')
local is_lspconfig, lspconfig = pcall(require, 'lspconfig')
local is_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if is_nvim_lsp_installer then
  nvim_lsp_installer.setup()
  local installed_servers = nvim_lsp_installer.get_installed_servers()
  for _, installed_server in pairs(installed_servers) do
    for _, language in pairs(installed_server.languages) do
      table.insert(installed_languages, language)
    end
    if is_lspconfig and is_cmp_nvim_lsp then
      lspconfig[installed_server.name].setup {
        capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
      }

      if installed_server.name == 'sumneko_lua' then
        lspconfig[installed_server.name].setup {
          on_attach = mappings.nvim_lspconfig(),
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim', 'packer_plugins' }
              }
            }
          }
        }
      end
    end
  end
end

local is_nvim_tree, nvim_tree = pcall(require, 'nvim-tree')
if is_nvim_tree then
  nvim_tree.setup {
    disable_netrw = true,
    view = {
      width = 35,
      mappings = {
        list = mappings.nvim_tree()
      }
    },
    renderer = {
      indent_markers = {
        enable = true
      }
    },
    diagnostics = {
      enable = true
    },
    git = {
      enable = false,
    },
  }
end

local is_bufferline, bufferline = pcall(require, 'bufferline')
if is_bufferline then
  bufferline.setup {
    options = {
      tab_size = 25,
      sort_by = "insert_at_end",
      offsets = { { filetype = "NvimTree", text = "" } },
      separator_style = { "", "" }
    },
    highlights = {
      buffer_selected = {
        gui = "bold"
      },
      duplicate_selected = {
        gui = "bold"
      },
      duplicate_visible = {
        gui = "bold"
      },
      duplicate = {
        gui = "bold"
      },
    }
  }
end

local is_telescope, telescope = pcall(require, 'telescope')
if is_telescope then
  telescope.setup {
    on_attach = mappings.telescope(),
    pickers = {
      find_files = {
        hidden = true
      }
    }
  }
end

local is_nvim_treesitter_configs, nvim_treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if is_nvim_treesitter_configs then
  nvim_treesitter_configs.setup {
    ensure_installed = installed_languages,
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    }
  }
end

local is_formatter, formatter = pcall(require, 'formatter')
if is_formatter then
  formatter.setup {
    on_attach = mappings.formatter_nvim()
  }
end

local is_gitsigns, gitsigns = pcall(require, 'gitsigns')
if is_gitsigns then
  gitsigns.setup {
    signs = {
      delete = { text = '│' }
    },
    numhl = true
  }
end

if packer_plugins and packer_plugins['vim-commentary'] and packer_plugins['vim-commentary'].loaded then
  mappings.vim_commentary()
end

if packer_plugins and packer_plugins['neoterm'] and packer_plugins['neoterm'].loaded then
  mappings.neoterm()
  vim.g.neoterm_default_mod = 'botright vertical'
  vim.g.neoterm_size = 60
  vim.g.neoterm_autoinsert = 1
end

local is_colorizer, colorizer = pcall(require, 'colorizer')
if is_colorizer then
  colorizer.setup({'*'}, {
    RRGGBBAA = true;
	  css = true;
  })
end
