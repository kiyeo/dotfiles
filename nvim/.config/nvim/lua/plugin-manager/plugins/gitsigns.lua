return {
  'lewis6991/gitsigns.nvim', -- git decoration and actions
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▎' }
    },
    numhl = true,
    on_attach = function(buffer)
      vim.keymap.set('n', '[c', '&diff ? "[c" : ":Gitsigns next_hunk<CR>"',
        {
          buffer = buffer,
          expr = true,
          desc = 'gitsigns.nvim - Press [ + c to go to next hunk git changes'
        })
      vim.keymap.set('n', ']c', '&diff ? "]c" : ":Gitsigns prev_hunk<CR>"',
        {

          buffer = buffer,
          expr = true,
          desc = 'gitsigns.nvim - Press ] + c to go to previous hunk git changes'
        })
      vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + s to stage hunk'
        })
      vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>',
        {

          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + r to reset hunk'
        })
      vim.keymap.set('n', '<leader>hS', ':Gitsigns stage_buffer<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + S to stage file'
        })
      vim.keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + u to undo stage file'
        })
      vim.keymap.set('n', '<leader>hR', ':Gitsigns reset_buffer<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + R to reset stage file'
        })
      vim.keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + p to preview hunk'
        })
      vim.keymap.set('n', '<leader>hb', function() package.loaded.gitsigns.blame_line { full = true } end,
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + b to blame line'
        })
      vim.keymap.set('n', '<leader>tb', ':Gitsigns toggle_current_line_blame<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + t + b to toggle blame line'
        })
      vim.keymap.set('n', '<leader>hd', ':Gitsigns diffthis<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + d to see differences in current file'
        })
      vim.keymap.set('n', '<leader>hD', function() package.loaded.gitsigns.diffthis('~') end,
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' ..
              vim.g.mapleader .. '" + h + D to see differences in current file last commit'
        })
      vim.keymap.set('n', '<leader>td', ':Gitsigns toggle_deleted<CR>',
        {
          buffer = buffer,
          desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + t + d to see deleted lines in current file'
        })
    end
  }
}
