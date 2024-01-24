vim.opt.termguicolors = true      -- Enables 24-bit RGB color in the |TUI|
vim.opt.mouse = 'a'               -- enable mouse
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cursorline = true         -- highlight the text line of the cursor
vim.opt.hidden = true             -- enable hidden files
vim.wo.wrap = false               -- display long lines as just one line
vim.opt.signcolumn = "yes"        -- always show shift column
vim.opt.splitbelow = true         -- splitting a window will put the new window below the current one
vim.opt.splitright = true         -- splitting a window will put the new window right of the current one

vim.opt.expandtab = true          -- converts tabs to spaces
vim.opt.tabstop = 2               -- insert 2 spaces for a tab
vim.opt.shiftwidth = 2            -- number of spaces inserted for each indentation
vim.opt.number = true             -- line numbering

vim.opt.ignorecase = true         -- search insensitive
vim.opt.smartcase = true          -- except when inputting uppercase letters

vim.g.netrw_liststyle = 3         -- tree style directories
vim.g.python3_host_prog = '/usr/bin/python3.9'

vim.filetype.add({
  extension = {
    configbundle = "json"
  },
  pattern = {
    ['[.A-Z0-9]+b?'] = function(path, bufnr, ext)
      --print(path)
      --print(bufnr)
      --print(ext)
      return 'genbasic'
    end
  }
})

vim.lsp.set_log_level("debug")

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'genbasic',
  callback = function()
    vim.lsp.start({
      name = 'genbasic-ls',
      cmd = { 'node', '/home/leo/dev/genbasic-ls/server/out/server.js', '--stdio' },
      root_dir = vim.fn.getcwd()
    })
    local bufnr = vim.api.nvim_get_current_buf()
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
  end,
})


vim.api.nvim_create_autocmd("LspTokenUpdate", {
  callback = function(args)
    print(vim.inspect(args))
  end,
})
