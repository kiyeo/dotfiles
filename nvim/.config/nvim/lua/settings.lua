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
