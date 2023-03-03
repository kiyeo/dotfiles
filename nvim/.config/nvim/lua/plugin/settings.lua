local mappings = require('plugin.mappings')

local is_colorscheme, colorscheme_plugin = pcall(require, 'onenord')
if is_colorscheme then
  colorscheme_plugin.setup({
    custom_highlights = {
      BufferLineIndicatorSelected = { fg = "#88c0d0", bg = "#2e3440" },
      BufferLineFill = { fg = "#ECEFF4", bg = "#242932" },
      GitSignsChange = { fg = '#d08770' },
      GitSignsChangeNr = { fg = '#d08770' },
      GitSignsChangeLn = { fg = '#d08770' }
    }
  })
end

-- autocmd
local is_lualine, lualine = pcall(require, 'lualine')
if is_lualine then
  lualine.setup()
end

local is_nvim_tree, nvim_tree = pcall(require, 'nvim-tree')
if is_nvim_tree then
  nvim_tree.setup({
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
      enable = true,
    },
  })
end

local is_bufferline, bufferline = pcall(require, 'bufferline')
if is_bufferline then
  bufferline.setup({
    options = {
      tab_size = 25,
      sort_by = "insert_at_end",
      offsets = { { filetype = "NvimTree", text = "", padding = 1 }, { filetype = "toggleterm", text = "" } },
      separator_style = { "", "" }
    },
    highlights = {
      buffer_selected = {
        bold = true
      },
      duplicate_selected = {
        bold = true
      },
      duplicate_visible = {
        bold = true
      },
      duplicate = {
        bold = true
      },
    }
  })
end

local is_telescope, telescope = pcall(require, 'telescope')
if is_telescope then
  telescope.setup({
    on_attach = mappings.telescope(),
    pickers = {
      find_files = {
        hidden = true
      }
    }
  })
end

local is_nvim_treesitter_configs, nvim_treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if is_nvim_treesitter_configs then
  nvim_treesitter_configs.setup({
    ensure_installed = require('plugin.lsp_config').lsp_languages,
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
  })
end

local is_gitsigns, gitsigns = pcall(require, 'gitsigns')
if is_gitsigns then
  gitsigns.setup({
    on_attach = mappings.gitsigns(gitsigns),
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▎' }
    },
    numhl = true
  })
end

local is_comment, comment = pcall(require, 'Comment')
if is_comment then
  comment.setup({
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
  })
end

local is_toggleterm, toggleterm = pcall(require, 'toggleterm')
if is_toggleterm then
  toggleterm.setup({
    size = 80,
    open_mapping = mappings.toggleterm(toggleterm),
    shade_terminals = false,
    direction = 'vertical',
    start_in_insert = false,
    on_open = function() vim.cmd("startinsert!") end
  })
end

local is_colorizer, colorizer = pcall(require, 'colorizer')
if is_colorizer then
  colorizer.setup({ '*' }, {
    RRGGBBAA = true;
    css = true;
  })
end
