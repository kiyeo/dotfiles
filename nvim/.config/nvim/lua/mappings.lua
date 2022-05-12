-- use space as the leader key
vim.g.mapleader = ' '

-- 'n' is while in normal mode
-- 'i' is while in insert mode
-- 'v' is while in visual mode
-- 't' is while in terminal mode

vim.keymap.set({'i', 'v'}, 'fd', '<Esc>', {desc = 'Enter normal mode'})

vim.keymap.set('n', '<Tab>', ':bnext<CR>', {desc = 'Press Tab to move to the next buffer'})
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', {desc = 'Press Shift + Tab to move to the previous buffer'})
vim.keymap.set('n', '<C-w>', ':bdelete<CR>', {desc = 'Press Ctrl + w to move to the previous buffer'})

vim.keymap.set('n', '<Leader>e', 'v$', {desc = 'Press "' .. vim.g.mapleader .. '" + e to select till the end of the line'})
