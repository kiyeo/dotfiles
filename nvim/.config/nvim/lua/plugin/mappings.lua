local M = {}

function M.nvim_lspconfig()
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, {desc = 'nvim-lspconfig - Press g + d to goto definition'})
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, {desc = 'nvim-lspconfig - Press g + i to goto implementation'})
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, {desc = 'nvim-lspconfig - Press g + h to goto reference'})
  vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end, {desc = 'nvim-lspconfig - Press g + h to hover'})
  vim.keymap.set('n', '<Leader>rn', function() vim.lsp.buf.rename() end, {desc = 'nvim-lspconfig - Press "' .. vim.g.mapleader .. '" + r + n to rename'})
end

function M.nvim_cmp()
  local cmp = require("cmp")
  return {
		["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm { select = true },
  };
end

function M.telescope()
  vim.keymap.set('n', '<Leader><Leader>', function() require("telescope.builtin").find_files() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "'  .. vim.g.mapleader .. '" to fuzzy find files'})
end

function M.formatter_nvim()
  vim.keymap.set('n', '<Leader>F', ':Format<CR>', {desc = 'formatter.nvim - Press "' .. vim.g.mapleader .. '" + F to format file'})
end

function M.vim_commentary()
  vim.keymap.set({'n', 'v'}, '<C-_>', ':Commentary<CR>', {desc = 'vim-commentary - Press Ctrl + / to comment line/selection'})
end

function M.neoterm()
  vim.keymap.set({'n', 't'}, '<C-q>', '<C-\\><C-n>:Ttoggle<CR>', {desc = 'neoterm - Press Ctrl + q to toggle terminal'})
end

return M
