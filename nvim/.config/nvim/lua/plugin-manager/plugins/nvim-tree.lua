return {
  -- file explorer
  'kyazdani42/nvim-tree.lua',
  dependencies = {
    'kyazdani42/nvim-web-devicons' -- file icons
  },
  keys = {
    { '<Leader>e',  ':NvimTreeToggle <CR>',  desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "' .. vim.g.mapleader .. '" to fuzzy find files' },
    { '<Leader>fe', ':NvimTreeFindFile<CR>', desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "' .. vim.g.mapleader .. '" to fuzzy find files' }
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
