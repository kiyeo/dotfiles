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

local installed_languages = { 'tsx' }
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

      local function lua()
        if installed_server.name == 'sumneko_lua' then
          return {
            diagnostics = {
              globals = { 'vim', 'packer_plugins' }
            }
          }
        end
      end

      local function yaml()
        if installed_server.name == 'yamlls' then
          return {
            format = {
              enable = true,
            },
            hover = true,
            completion = true,
            customTags = {
              "!Base64 scalar",
              "!Cidr scalar",
              "!And sequence",
              "!Equals sequence",
              "!If sequence",
              "!Not sequence",
              "!Or sequence",
              "!Condition scalar",
              "!FindInMap sequence",
              "!GetAtt scalar",
              "!GetAZs scalar",
              "!ImportValue scalar",
              "!Join sequence",
              "!Select sequence",
              "!Split sequence",
              "!Sub scalar",
              "!Transform mapping",
              "!Ref scalar",
            },
          }
        end
      end

      lspconfig[installed_server.name].setup {
        on_attach = mappings.nvim_lspconfig(),
        settings = {
          Lua = lua(),
          yaml = yaml()
        }
      }
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
      offsets = { { filetype = "NvimTree", text = "", padding = 1 }, { filetype = "toggleterm", text = "" } },
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
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false
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
    on_attach = mappings.gitsigns(),
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▎' }
    },
    numhl = true
  }
end

local is_dap, dap = pcall(require, 'dap')
if is_dap then
  mappings.nvim_dap()
  dap.defaults.fallback.terminal_win_cmd = '20split new'
  vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#E06C75' }, false)
  vim.highlight.create('DapBreakpointRejected', { ctermbg=0, guifg='#61afef' }, false)
  vim.highlight.create('DapStopped', { ctermbg=0, guifg='#E06C75' }, false)
  vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='', numhl='DapBreakpoint'})
  vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointRejected', linehl='', numhl='DapBreakpointRejected'})
  vim.fn.sign_define('DapStopped', {text='卑', texthl='DapStopped', linehl='', numhl='DapStopped'})

  local debug_adapters = {
    'microsoft/vscode-node-debug2',
  }
  for _, debug_adapter in ipairs(debug_adapters) do
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/' .. debug_adapter
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/' .. debug_adapter, install_path})
    end

    if debug_adapter == 'microsoft/vscode-node-debug2' then
      if vim.fn.empty(vim.fn.glob(install_path .. '/out/src/')) > 0 then
        vim.cmd('!cd ' .. install_path .. ' && npm install && npm run build')
      end
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { install_path .. '/out/src/nodeDebug.js' }
      }
    end
  end
end

local is_comment, comment = pcall(require, 'Comment')
if is_comment then
  comment.setup {
    pre_hook = function(ctx)
      local U = require("Comment.utils")

      local location = nil
      if ctx.ctype == U.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring {
        key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
        location = location,
      }
    end
  }
end

local is_toggleterm, toggleterm = pcall(require, 'toggleterm')
if is_toggleterm then
  toggleterm.setup {
    size = 60,
    open_mapping = mappings.toggleterm(),
    shade_terminals = false,
    direction = 'vertical',
    start_in_insert = false,
    on_open = function() vim.cmd("startinsert!") end
  }
end

local is_colorizer, colorizer = pcall(require, 'colorizer')
if is_colorizer then
  colorizer.setup({'*'}, {
    RRGGBBAA = true;
	  css = true;
  })
end
