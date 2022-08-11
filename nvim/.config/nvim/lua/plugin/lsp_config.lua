local mappings = require('plugin.mappings')

local is_mason, mason = pcall(require, 'mason')
local is_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
local is_lspconfig, lspconfig = pcall(require, 'lspconfig')
local is_lsp_format, lsp_format = pcall(require, 'lsp-format')
local is_cmp_nvim_lsp, cmp_nvim_lsp = require('plugin.cmp').cmp_nvim_lsp()
if is_mason and is_mason_lspconfig then
  mason.setup()
  if is_lsp_format then
    lsp_format.setup()
  end

  local installed_servers = mason_lspconfig.get_installed_servers()
  for _, installed_server in pairs(installed_servers) do
    if is_lspconfig then
      local on_attach = function(client, bufnr)
        if installed_server ~= 'tsserver' then
          client.resolved_capabilities.document_formatting = true
        else
          client.resolved_capabilities.document_formatting = false
        end
        if is_lsp_format then
          lsp_format.on_attach(client)
        end
        mappings.nvim_lspconfig(bufnr)
      end

      local function lua()
        if installed_server == 'sumneko_lua' then
          return {
            diagnostics = {
              globals = { 'vim', 'packer_plugins' }
            }
          }
        end
      end

      local function yaml()
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
      end

      local function typescriptHandler()
        if installed_server == 'tsserver' then
          return {
            ['textDocument/publishDiagnostics'] = function() end
          }
        end
      end

      local function cmp_nvim_lsp_capabilities()
        if is_cmp_nvim_lsp then
          return cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
        end
      end

      lspconfig[installed_server].setup({
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp_capabilities(),
        init_options = { documentFormatting = true },
        settings = {
          Lua = lua(),
          yaml = yaml(),
        },
        handlers = typescriptHandler()
      })
    end
  end
end
