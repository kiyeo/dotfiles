-- use space as the leader key
vim.g.mapleader = ' '

-- 'n' is while in normal mode
-- 'i' is while in insert mode
-- 'v' is while in visual mode
-- 'x' is while in visual block mode
-- 't' is while in terminal mode
-- 'c' is while in command mode

vim.keymap.set({ 'i', 'v', 'c' }, 'fd', '<Esc>', { desc = 'Enter normal mode' })
vim.keymap.set({ 'n', 't' }, '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Exit terminal mode and move to left window' })
vim.keymap.set({ 'n', 't' }, '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Exit terminal mode and move to below window' })
vim.keymap.set({ 'n', 't' }, '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Exit terminal mode and move to right window' })
vim.keymap.set({ 'n', 't' }, '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Exit terminal mode and move to above window' })

vim.keymap.set('n', '<C-h>', ':bnext<CR>', { desc = 'Press Tab to move to the next buffer' })
vim.keymap.set('n', '<C-l>', ':bprevious<CR>', { desc = 'Press Shift + Tab to move to the previous buffer' })
vim.keymap.set('n', '<Leader>w', ':bp | :bd #<CR>', { desc = 'Press "' .. vim.g.mapleader .. '" + w to delete the current buffer' })
vim.keymap.set('t', '<A-w>', '<C-\\><C-n>:bdelete!<CR>', { desc = 'Press "' .. vim.g.mapleader .. '" + w to exit terminal mode and delete the buffer' })
vim.keymap.set('n', '<Leader>e', ':Lexplore 30<CR>', { desc = 'Press "' .. vim.g.mapleader .. '" + e to open Netrw' })

vim.keymap.set({ 'n', 'x' }, '<Leader>ll', 'v$h', { desc = 'Press "' .. vim.g.mapleader .. '" + e + l to select till the end of the line' })
