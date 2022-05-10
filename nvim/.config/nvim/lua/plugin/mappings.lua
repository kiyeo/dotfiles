vim.keymap.set('n', '<C-q>', ':Ttoggle<CR>', {desc = 'neoterm - Press Ctrl + q to toggle terminal'})

vim.keymap.set('n', '<Leader>F', ':Format<CR>', {desc = 'formatter.nvim - Press "' .. vim.g.mapleader .. '" + F to format file'})

vim.keymap.set('n', '<C-_>', ':Commentary<CR>', {desc = 'vim-commentary - Press Ctrl + / to comment line'})
vim.keymap.set('v', '<C-_>', ':Commentary<CR>', {desc = 'vim-commentary - Press Ctrl + / to comment selection'})

vim.keymap.set('n', '<Leader><Leader>', function() require("telescope.builtin").find_files() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "'  .. vim.g.mapleader .. '" to fuzzy find files'})

vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, {desc = 'nvim-lspconfig - Press g + d to goto definition'})
vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, {desc = 'nvim-lspconfig - Press g + i to goto implementation'})
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, {desc = 'nvim-lspconfig - Press g + h to goto reference'})
vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end, {desc = 'nvim-lspconfig - Press g + h to hover'})
vim.keymap.set('n', '<Leader>rn', function() vim.lsp.buf.rename() end, {desc = 'nvim-lspconfig - Press "' .. vim.g.mapleader .. '" + r + n to rename'})
