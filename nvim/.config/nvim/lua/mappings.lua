-- use space as the leader key
vim.g.mapleader = ' '

-- 'n' is while in normal mode
-- 'i' is while in insert mode
-- 'v' is while in visual mode
-- 'x' is while in visual block mode
-- 't' is while in terminal mode
-- 'c' is while in command mode

vim.keymap.set({'i', 'v', 'c'}, 'fd', '<Esc>', {desc = 'Enter normal mode'})
vim.keymap.set('t', '<Leader>fd', '<Esc>', {desc = 'Enter normal mode in terminal mode'})
vim.keymap.set('t', '<Leader>fdn', '<C-\\><C-n>', {desc = 'Exit terminal mode and enter normal mode'})

vim.keymap.set('n', '<Tab>', ':bnext<CR>', {desc = 'Press Tab to move to the next buffer'})
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', {desc = 'Press Shift + Tab to move to the previous buffer'})
vim.keymap.set('n', '<Leader>w', ':bdelete<CR>', {desc = 'Press "' .. vim.g.mapleader .. '" + w to delete the current buffer'})
vim.keymap.set('t', '<Leader>w', '<C-\\><C-n>:bdelete!<CR>', {desc = 'Press "' .. vim.g.mapleader .. '" + w to exit terminal mode and delete the buffer'})

vim.keymap.set('n', '<Leader>le', ':Lexplore 30<CR>', {desc = 'Press "' .. vim.g.mapleader .. '" + e to open Netrw'})

vim.keymap.set({'n', 'x'}, '<Leader>el', 'v$h', {desc = 'Press "' .. vim.g.mapleader .. '" + e + l to select till the end of the line'})
