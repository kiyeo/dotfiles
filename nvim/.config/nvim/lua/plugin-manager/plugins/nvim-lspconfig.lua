return {
  -- language server protocol
  'neovim/nvim-lspconfig', -- configurations for Nvim LSP
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    'williamboman/mason-lspconfig.nvim', -- extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
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
    on_attach = function(client, bufnr, installed_server)
      if installed_server == 'tsserver' then
        client.server_capabilities.documentFormattingProvider = false
      else
        client.server_capabilities.documentFormattingProvider = true
      end
      require('lsp-format').on_attach(client)

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
    capabilities = function()
      return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    end
  },
  config = function(_, opts)
    local is_lspconfig, lspconfig = pcall(require, 'lspconfig')
    local is_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
    if not (is_lspconfig and is_mason_lspconfig) then
      return
    end
    local installed_servers = mason_lspconfig.get_installed_servers()

    for _, installed_server in pairs(installed_servers) do
      if installed_server == 'omnisharp' then
        local pid = vim.fn.getpid()
        lspconfig[installed_server].setup({
          on_attach = function(client, bufnr)
            opts.on_attach(client, bufnr, installed_server)
          end,
          capabilities = opts.capabilities(),
          init_options = { documentFormatting = true },
          cmd = {
            vim.fn.stdpath('data') .. '/mason/bin/omnisharp',
            '--languageserver',
            '--hostPID',
            tostring(pid)
          },
        })
      else
        lspconfig[installed_server].setup({
          on_attach = function(client, bufnr)
            opts.on_attach(client, bufnr, installed_server)
          end,
          capabilities = opts.capabilities(),
          init_options = (function()
            if installed_server ~= 'terraformls' then
              return { documentFormatting = true }
            end
          end)(),
          settings = {
            Lua = (function()
              if installed_server == 'lua_ls' then
                return {
                  diagnostics = {
                    globals = { 'vim' }
                  }
                }
              end
            end)(),
            yaml = (function()
              if installed_server == 'yamlls' then
                return {
                  format = {
                    enable = true,
                  },
                  hover = true,
                  completion = true,
                  customTags = {
                    "!Base64 scalar",
                    "!Cidr scalar",
                    "!And sequence",
                    "!Equals sequence",
                    "!If sequence",
                    "!Not sequence",
                    "!Or sequence",
                    "!Condition scalar",
                    "!FindInMap sequence",
                    "!GetAtt scalar",
                    "!GetAZs scalar",
                    "!ImportValue scalar",
                    "!Join sequence",
                    "!Select sequence",
                    "!Split sequence",
                    "!Sub scalar",
                    "!Transform mapping",
                    "!Ref scalar",
                  },
                }
              end
            end)(),
            java = (function()
              if installed_server == 'jdtls' then
                return {
                  configuration = {
                    runtimes = {
                      {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk-amd64/",
                      }
                    }
                  }
                }
              end
            end)()
          }
        })
      end
    end
  end
}
