-- Java Setup
local is_jdtls, jdtls = pcall(require, 'jdtls')
if not is_jdtls then
  print('jdtls is not installed.')
  vim.ui.input({ prompt = 'Run `Lazy install nvim-jdtls`? (Y/n): ' },
    function(user_input)
      if user_input == '' or user_input == nil or user_input == 'Y' or user_input == 'y' then
        local is_lazy, lazy = pcall(require, 'lazy')
        if not is_lazy then
          print('lazy is not installed')
          return
        end
        lazy.install({ wait = true, plugins = { 'nvim-jdtls' } })
      else
        return
      end
    end
  )
end

local jdtls_path = vim.fn.stdpath('data') .. '/mason/share/jdtls'
local config_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
os.execute('mkdir ' .. workspace_dir)

-- Needed for debugging
local bundles = {
  vim.fn.glob(vim.fn.stdpath('data') .. '/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath('data') .. '/mason/share/java-test/*.jar', 1), '\n'))

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  cmd = {
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher.jar',
    '-configuration', config_path,
    '-data', workspace_dir,
  },
  root_dir = require('jdtls.setup').find_root({ '.project', '.git', 'mvnw', 'pom.xml', 'build.gradle' }),

  settings = {
    java = {
      eclipse = { downloadSources = true, },
      maven = { downloadSources = true, },
      implementationsCodeLens = { enabled = true, },
      referencesCodeLens = { enabled = true, },
      references = { enabled = true, },
      signatureHelp = { enabled = true },

      project = {
        outputPath = 'bin',
        sourcesPaths = { 'src', 'test' }
      },

      configuration = {
        updateBuildConfiguration = 'interactive',
      },

      format = {
        enabled = true,
        comments = true,
        settings = {
          url = vim.fn.stdpath('config') .. '/utils/eclipse-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
    },


    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org'
      },
    },

    extendedClientCapabilities = extendedClientCapabilities,

    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },

  -- Needed for auto-completion with method signatures and placeholders
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),

  init_options = {
    bundles = bundles,
  },

}

config.on_attach = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = 'auto' })

  local is_jdtls_dap, jdtls_dap = pcall(require, 'jdtls.dap')
  if not is_jdtls_dap then
    print('jdtls.dap is not installed')
    return
  end
  jdtls_dap.setup_dap_main_class_configs()
  --   require('keymaps').map_java_keys(bufnr)

  vim.keymap.set('n', "<leader>lo", jdtls.organize_imports, { desc = 'jdtls - Organize imports', buffer = bufnr })
  vim.keymap.set('n', "<leader>tc", jdtls.test_class, { desc = 'jdtls - Test class', buffer = bufnr })
  vim.keymap.set('n', "<leader>tm", jdtls.test_nearest_method, { desc = 'jdtls - Test method', buffer = bufnr })
  vim.keymap.set('n', '<leader>lrv', jdtls.extract_variable_all, { desc = 'jdtls - Extract variable', buffer = bufnr })
  vim.keymap.set('v', '<leader>lrm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { desc = 'jdtls - Extract method', buffer = bufnr })
  vim.keymap.set('n', '<leader>lrc', jdtls.extract_constant, { desc = 'jdtls - Extract constant', buffer = bufnr })
end

jdtls.start_or_attach(config)
