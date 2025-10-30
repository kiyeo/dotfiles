return {
  -- fuzzy finder
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    pickers = {
      find_files = {
        hidden = true
      }
    }
  },
  keys = {
    { '<Leader><Leader>', ':Telescope find_files hidden=true<CR>', desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + "' .. vim.g.mapleader .. '" to fuzzy find files' },
    { '<Leader>fb',       ':Telescope buffers<CR>',                desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + f + b to list buffers' },
    { '<Leader>fg',       ':Telescope git_status<CR>',             desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + f + g to list file\'s git status' },
    { '<Leader>fi',       ':Telescope live_grep<CR>',              desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + f + i to search files by content' }
  },
}
