return {
  -- file explorer
  'kyazdani42/nvim-tree.lua',
  dependencies = {
    'kyazdani42/nvim-web-devicons' -- file icons
  },
  keys = {
    { '<Leader>e',  ':NvimTreeToggle <CR>',  desc = 'nvim-tree - Press "' .. vim.g.mapleader .. '" + e to open file explorer' },
    { '<Leader>fe', ':NvimTreeFindFile<CR>', desc = 'nvim-tree - Press "' .. vim.g.mapleader .. '" + f + e to find file in the file explorer' }
  },
  opts = {
    disable_netrw = true,
    view = {
      width = 35,
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
  },
}
