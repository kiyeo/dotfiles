return {
  -- language server protocol
  'neovim/nvim-lspconfig', -- configurations for Nvim LSP
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim', -- extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
    'lukas-reineke/lsp-format.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  keys = {
    { '<Leader>F', vim.lsp.buf.formatting,    desc = 'lsp-format.nvim - Press "' .. vim.g.mapleader .. '" + F to format file' },
    { "ga",        vim.lsp.buf.code_action,   desc = 'lsp-format.nvim - Press g + a for code actions' },
    { 'gl',        vim.diagnostic.open_float, desc = 'nvim-lspconfig - Press g + l to open diagnostic' },
    { '<C-n>',     vim.diagnostic.goto_next,  desc = 'nvim-lspconfig - Press ctrl + n to go to next diagnostic' },
    { '<C-p>',     vim.diagnostic.goto_prev,  desc = 'nvim-lspconfig - Press ctrl + p to go to previous diagnostic' }
  },
  opts = {
    on_attach = function(client, bufnr)
      require('lsp-format').on_attach(client)

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
    capabilities = function()
      return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    end
  },
  config = function(_, opts)
    local is_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
    if not (is_mason_lspconfig) then
      print('mason-lspconfig is not installed')
      return
    end
    local installed_servers = mason_lspconfig.get_installed_servers()

    vim.lsp.config('*', {
      on_attach = opts.on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    })

    vim.lsp.enable(installed_servers)
  end
}
