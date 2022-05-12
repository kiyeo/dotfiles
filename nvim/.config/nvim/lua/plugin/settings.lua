local mappings = require('plugin.mappings')

local colorscheme_plugin = packer_plugins['zephyr-nvim']
if colorscheme_plugin and colorscheme_plugin.loaded then
  require('zephyr')
end

local installed_languages = {}
local nvim_lsp_installer_plugin = packer_plugins['nvim-lsp-installer']
local nvim_lspconfig_plugin = packer_plugins['nvim-lspconfig']
if nvim_lsp_installer_plugin and nvim_lsp_installer_plugin.loaded and nvim_lspconfig_plugin and nvim_lspconfig_plugin.loaded then
  require('nvim-lsp-installer').setup {}
  local installed_servers = require('nvim-lsp-installer').get_installed_servers()
  for _, installed_server in pairs(installed_servers) do
    for _, language in pairs(installed_server.languages) do
      table.insert(installed_languages, language)
    end
    require('lspconfig')[installed_server.name].setup {
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }

    if installed_server.name == 'sumneko_lua' then
      require('lspconfig')[installed_server.name].setup {
        on_attach = mappings.nvim_lspconfig(),
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim', 'packer_plugins' }
            }
          }
        }
      }
    end
  end
end

local telescope_plugin = packer_plugins['telescope.nvim']
if telescope_plugin and telescope_plugin.loaded then
  require("telescope").setup {
    on_attach = mappings.telescope()
  }
end

local treesitter_plugin = packer_plugins['nvim-treesitter']
if treesitter_plugin and treesitter_plugin.loaded then
  require('nvim-treesitter.configs').setup {
    ensure_installed = installed_languages,
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    }
  }
end

local formatter_plugin = packer_plugins['formatter.nvim']
if formatter_plugin and formatter_plugin.loaded then
  require('formatter').setup {
    on_attach = mappings.formatter_nvim()
  }
end

local gitsigns_plugin = packer_plugins['gitsigns.nvim']
if gitsigns_plugin and gitsigns_plugin.loaded then
  require('gitsigns').setup {}
end

local neoterm_plugin = packer_plugins['neoterm']
if neoterm_plugin and neoterm_plugin.loaded then
  mappings.neoterm()
  vim.g.neoterm_default_mod = 'botright vertical'
  vim.g.neoterm_size = 60
  vim.g.neoterm_autoinsert = 1
end
