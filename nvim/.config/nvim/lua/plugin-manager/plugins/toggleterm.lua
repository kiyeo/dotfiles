return {
  'akinsho/toggleterm.nvim', -- terminal
  config = function()
    local is_toggleterm, toggleterm = pcall(require, 'toggleterm')
    if not (is_toggleterm) then
      print("toggleterm not found")
      return
    end
    toggleterm.setup({
      size = 80,
      --open_mapping = function()
      shade_terminals = false,
      direction = 'vertical',
      start_in_insert = false,
      on_open = function() vim.cmd("startinsert!") end,
    })

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
            if user_input == '' or user_input == nil or user_input == 'A' or user_input == 'a' then
              toggleterm.toggle_all()
            elseif tonumber(user_input) then
              toggleterm.toggle(tonumber(user_input))
            end
          end
        )
      end,
      { desc = 'toggleterm - Press "' .. vim.g.mapleader .. '" + t + s to be prompted to select terminal' })
  end
}
