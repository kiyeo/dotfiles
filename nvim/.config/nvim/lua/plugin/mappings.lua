local M = {}

function M.nvim_lspconfig()
  vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, {desc = 'nvim-lspconfig -  Press g + l to open diagnostic'})
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, {desc = 'nvim-lspconfig -     Press g + d to goto definition'})
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, {desc = 'nvim-lspconfig - Press g + i to goto implementation'})
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, {desc = 'nvim-lspconfig -     Press g + h to goto reference'})
  vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end, {desc = 'nvim-lspconfig -          Press g + h to hover'})
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
  vim.keymap.set('n', '<Leader><Leader>', ':Telescope find_files hidden=true<CR>', {desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + "'  .. vim.g.mapleader .. '" to fuzzy find files'})
  vim.keymap.set('n', '<Leader>fb', ':Telescope buffers<CR>', {desc = 'telescope.nvim -                      Press "' .. vim.g.mapleader .. '" + f + b to list buffers'})
  vim.keymap.set('n', '<Leader>fg', ':Telescope git_status<CR>', {desc = 'telescope.nvim -                   Press "' .. vim.g.mapleader .. '" + f + g to list file\'s git status'})
  vim.keymap.set('n', '<Leader>fi', ':Telescope live_grep<CR>', {desc = 'telescope.nvim -                    Press "' .. vim.g.mapleader .. '" + f + i to search files by content'})
end

function M.formatter_nvim()
  vim.keymap.set('n', '<Leader>F', ':Format<CR>', {desc = 'formatter.nvim - Press "' .. vim.g.mapleader .. '" + F to format file'})
end

function M.gitsigns()
  vim.keymap.set('n', '[c', "&diff ? '[c' : ':Gitsigns next_hunk<CR>'", {expr=true, desc = 'gitsigns.nvim -            Press [ + c to go to next hunk git changes'})
  vim.keymap.set('n', ']c', "&diff ? ']c' : ':Gitsigns prev_hunk<CR>'", {expr=true, desc = 'gitsigns.nvim -            Press ] + c to go to previous hunk git changes'})
  vim.keymap.set({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', {desc = 'gitsigns.nvim -                        Press "' .. vim.g.mapleader .. '" + h + s to stage hunk'})
  vim.keymap.set({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', {desc = 'gitsigns.nvim -                        Press "' .. vim.g.mapleader .. '" + h + r to reset hunk'})
  vim.keymap.set('n', '<leader>hS', ':Gitsigns stage_buffer<CR>', {desc = 'gitsigns.nvim -                             Press "' .. vim.g.mapleader .. '" + h + S to stage file'})
  vim.keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>', {desc = 'gitsigns.nvim -                          Press "' .. vim.g.mapleader .. '" + h + u to undo stage file'})
  vim.keymap.set('n', '<leader>hR', ':Gitsigns reset_buffer<CR>', {desc = 'gitsigns.nvim -                             Press "' .. vim.g.mapleader .. '" + h + R to reset stage file'})
  vim.keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', {desc = 'gitsigns.nvim -                             Press "' .. vim.g.mapleader .. '" + h + p to preview hunk'})
  vim.keymap.set('n', '<leader>hb', function() require('gitsigns').blame_line{full=true} end, {desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + b to blame line'})
  vim.keymap.set('n', '<leader>tb', ':Gitsigns toggle_current_line_blame<CR>', {desc = 'gitsigns.nvim -                Press "' .. vim.g.mapleader .. '" + t + b to toggle blame line'})
  vim.keymap.set('n', '<leader>hd', ':Gitsigns diffthis<CR>', {desc = 'gitsigns.nvim -                                 Press "' .. vim.g.mapleader .. '" + h + d to see differences in current file'})
  vim.keymap.set('n', '<leader>hD', function() require('gitsigns').diffthis('~') end, {desc = 'gitsigns.nvim -         Press "' .. vim.g.mapleader .. '" + h + D to see differences in current file last commit'})
  vim.keymap.set('n', '<leader>td', ':Gitsigns toggle_deleted<CR>', {desc = 'gitsigns.nvim -                           Press "' .. vim.g.mapleader .. '" + t + d to see deleted lines in current file'})
end

function M.toggleterm()
  vim.keymap.set({'n', 't'}, '<C-q>', '<C-\\><C-n>:ToggleTerm<CR>', {desc = 'toggleterm - Press Ctrl + q to toggle terminal'})
  vim.keymap.set({'n', 't'}, '<Leader>ts',
    function ()
      local toggleterm = require('toggleterm')
      if #require('toggleterm.terminal').get_all() == 0 then
        toggleterm.toggle(1)
        return
      end
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
