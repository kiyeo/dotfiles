local M = {}

function M.nvim_lspconfig(bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- Enable completion triggered by <c-x><c-o>
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
    { desc = 'nvim-lspconfig - Press g + d to goto definition', buffer = bufnr })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
    { desc = 'nvim-lspconfig - Press g + i to goto implementation', buffer = bufnr })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references,
    { desc = 'nvim-lspconfig - Press g + r to goto reference', buffer = bufnr })
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover,
    { desc = 'nvim-lspconfig - Press g + h to hover', buffer = bufnr })
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename,
    { desc = 'nvim-lspconfig - Press "' .. vim.g.mapleader .. '" + r + n to rename', buffer = bufnr })
  vim.keymap.set('n', '<Leader>F', vim.lsp.buf.formatting,
    { desc = 'lsp-format.nvim - Press "' .. vim.g.mapleader .. '" + F to format file', buffer = bufnr })
  vim.keymap.set("n", "ga", vim.lsp.buf.code_action,
    { desc = 'lsp-format.nvim - Press g + a for code actions', buffer = bufnr })
  vim.keymap.set('n', 'gl', vim.diagnostic.open_float,
    { desc = 'nvim-lspconfig - Press g + l to open diagnostic', buffer = bufnr })
end

function M.nvim_cmp(cmp)
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
  vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle <CR>',
    { desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "' .. vim.g.mapleader .. '" to fuzzy find files' })
  vim.keymap.set('n', '<Leader>fe', ':NvimTreeFindFile<CR>',
    { desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" "' .. vim.g.mapleader .. '" to fuzzy find files' })
end

function M.telescope()
  vim.keymap.set('n', '<Leader><Leader>', ':Telescope find_files hidden=true<CR>',
    { desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + "' .. vim.g.mapleader .. '" to fuzzy find files' })
  vim.keymap.set('n', '<Leader>fb', ':Telescope buffers<CR>',
    { desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + f + b to list buffers' })
  vim.keymap.set('n', '<Leader>fg', ':Telescope git_status<CR>',
    { desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + f + g to list file\'s git status' })
  vim.keymap.set('n', '<Leader>fi', ':Telescope live_grep<CR>',
    { desc = 'telescope.nvim - Press "' .. vim.g.mapleader .. '" + f + i to search files by content' })
end

function M.gitsigns(gitsigns)
  vim.keymap.set('n', '[c', "&diff ? '[c' : ':Gitsigns next_hunk<CR>'",
    { expr = true, desc = 'gitsigns.nvim - Press [ + c to go to next hunk git changes' })
  vim.keymap.set('n', ']c', "&diff ? ']c' : ':Gitsigns prev_hunk<CR>'",
    { expr = true, desc = 'gitsigns.nvim - Press ] + c to go to previous hunk git changes' })
  vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + s to stage hunk' })
  vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + r to reset hunk' })
  vim.keymap.set('n', '<leader>hS', ':Gitsigns stage_buffer<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + S to stage file' })
  vim.keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + u to undo stage file' })
  vim.keymap.set('n', '<leader>hR', ':Gitsigns reset_buffer<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + R to reset stage file' })
  vim.keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + p to preview hunk' })
  vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end,
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + b to blame line' })
  vim.keymap.set('n', '<leader>tb', ':Gitsigns toggle_current_line_blame<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + t + b to toggle blame line' })
  vim.keymap.set('n', '<leader>hd', ':Gitsigns diffthis<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + d to see differences in current file' })
  vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis('~') end,
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + h + D to see differences in current file last commit' })
  vim.keymap.set('n', '<leader>td', ':Gitsigns toggle_deleted<CR>',
    { desc = 'gitsigns.nvim - Press "' .. vim.g.mapleader .. '" + t + d to see deleted lines in current file' })
end

function M.nvim_dap(dap)
  vim.keymap.set('n', '<Leader>db', ':DapToggleBreakpoint<CR>',
    { desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + b to create or remove a breakpoint at the current line.' })
  vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
    { desc = 'nvim-dap - Press "' ..
        vim.g.mapleader ..
        '" + d + B to guarantee overwriting of previous breakpoint. Otherwise, same as toggle_breakpoint.' })
  vim.keymap.set('n', '<Leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
    { desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + l + p to log message and set_breakpoint.' })
  vim.keymap.set('n', '<A-h>', ':DapContinue<CR>',
    { desc = 'nvim-dap - Press Alt + h to resume the execution of an application if a debug session is active and a thread was stopped.' })
  vim.keymap.set('n', '<A-j>', ':DapStepInto<CR>',
    { desc = 'nvim-dap - Press Alt + j to request the debugee to step into a function or method if possible.' })
  vim.keymap.set('n', '<A-k>', ':DapStepOver<CR>',
    { desc = 'nvim-dap - Press Alt + k to request the debugee to run again for one step.' })
  vim.keymap.set('n', '<A-l>', ':DapStepOut<CR>',
    { desc = 'nvim-dap -  Press Alt + l to request the debugee to step out of a function or method if possible.' })
  vim.keymap.set('n', '<leader>ds',
    ':lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.scopes)<CR>')
  vim.keymap.set({ 'n', 'v' }, '<leader>dh', ':lua require("dap.ui.widgets").hover()<CR>')
  vim.keymap.set('n', '<Leader>dr', ':DapToggleRepl<CR>',
    { desc = 'nvim-dap - Press "' ..
        vim.g.mapleader .. '" + d + r to opens the REPL if it is closed, otherwise closes it.' })
  vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end,
    { desc = 'nvim-dap - Press "' ..
        vim.g.mapleader .. '" + d + l to re-runs the last debug adapter / configuration that ran using dap.run().' })
  vim.keymap.set('n', '<leader>dk', function() dap.up() end,
    { desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + k to go up in current stacktrace without stepping.' })
  vim.keymap.set('n', '<leader>dj', function() dap.down() end,
    { desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + j to go down in current stacktrace without stepping.' })
  vim.keymap.set('n', '<leader>da', function() dap.attach() end,
    { desc = 'nvim-dap - Press "' ..
        vim.g.mapleader ..
        '" d + a to attach a running debug adapter and then initialize it with the given dap-configuration.' })
end

function M.toggleterm(toggleterm)
  vim.keymap.set({ 'n', 't' }, '<C-q>', '<C-\\><C-n>:ToggleTerm<CR>',
    { desc = 'toggleterm - Press Ctrl + q to toggle terminal' })
  vim.keymap.set({ 'n', 't' }, '<C-t>s',
    function()
      if #require('toggleterm.terminal').get_all() == 0 then
        toggleterm.toggle(1)
        return
      end
      vim.ui.input({ prompt = 'Enter terminal number (A/a/[0-9]+): ' },
        function(user_input)
          if user_input == nil or user_input == 'A' or user_input == 'a' then
            toggleterm.toggle_all()
          elseif tonumber(user_input) then
            toggleterm.toggle(tonumber(user_input))
          end
        end
      )
    end,
    { desc = 'toggleterm - Press "' .. vim.g.mapleader .. '" + t + s to be prompted to select terminal' })
end

return M
