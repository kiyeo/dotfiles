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
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
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

function M.nvim_tree()
  vim.keymap.set('n', '<Leader>e', function() require("nvim-tree").toggle() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "'  .. vim.g.mapleader .. '" to fuzzy find files'})
end

function M.telescope()
  vim.keymap.set('n', '<Leader><Leader>', function() require("telescope.builtin").find_files() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + "'  .. vim.g.mapleader .. '" to fuzzy find files'})
  vim.keymap.set('n', '<Leader>gf', function() require("telescope.builtin").git_files() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + g + f to fuzzy find git files'})
  vim.keymap.set('n', '<Leader>gs', function() require("telescope.builtin").grep_string() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + g + s to search files by string under cursor'})
  vim.keymap.set('n', '<Leader>lg', function() require("telescope.builtin").live_grep() end, {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + l + g to search files by content'})
end

function M.formatter_nvim()
  vim.keymap.set('n', '<Leader>F', ':Format<CR>', {desc = 'formatter.nvim - Press "' .. vim.g.mapleader .. '" + F to format file'})
end

function M.vim_commentary()
  vim.keymap.set({'n', 'v'}, '<C-_>', ':Commentary<CR>', {desc = 'vim-commentary - Press Ctrl + / to comment line/selection'})
end

function M.toggleterm()
  vim.keymap.set({'n', 't'}, '<C-q>', '<C-\\><C-n>:ToggleTerm<CR>', {desc = 'toggleterm - Press Ctrl + q to toggle terminal'})
  vim.keymap.set({'n', 't'}, '<Leader>ts',
    function ()
      if #require('toggleterm.terminal').get_all() == 0 then
        print('No terminals open')
        return
      end
      local toggleterm = require('toggleterm')
      vim.ui.input({ prompt = 'Enter terminal number (A/a/[0-9]+): ' },
        function(user_input)
          if user_input == nil or user_input == 'A' or user_input == 'a' then
            toggleterm.toggle_all()
          else
            toggleterm.toggle(tonumber(user_input))
          end
        end
      )
    end,
  {desc = 'toggleterm - Press "' .. vim.g.mapleader .. '" + t + s to be prompted to select terminal'})
end

return M