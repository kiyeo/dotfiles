local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = os.getenv("HOME") .. "/.cache/jdtls/workspace/" .. project_name

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    jdtls_path .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    '-configuration', jdtls_path .. '/config_linux',
    '-data', workspace_dir,
  },

  root_dir = require('jdtls.setup').find_root({ 'mvnw', 'gradlew' }),
  capabilities = capabilities,

  settings = {
    java = {
    }
  },

  init_options = {
    bundles = {}
  },
}

require('jdtls').start_or_attach(config)
