local mappings = require('plugin.mappings')

local M = {}

function M.dap_configuration()
  local is_dap, dap = pcall(require, 'dap')
  local is_nvim_dap_virtual_text, nvim_dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
  if is_dap then
    if is_nvim_dap_virtual_text then
      nvim_dap_virtual_text.setup()
    end
    mappings.nvim_dap(dap)
    dap.defaults.fallback.terminal_win_cmd = '20split new'
    vim.highlight.create('DapBreakpoint', { ctermbg = 0, guifg = '#E06C75', guibg = 0 }, false)
    vim.highlight.create('DapBreakpointRejected', { ctermbg = 0, guifg = '#ffaf00', guibg = 0 }, false)
    vim.highlight.create('DapStopped', { ctermbg = 0, guifg = '#88bf6a', guibg = 0 }, false)
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected',
      { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = 'DapBreakpointRejected' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = '', numhl = 'DapStopped' })

    dap.adapters.chrome = {
      type = 'executable';
      command = 'node',
      args = { vim.fn.stdpath("data") .. '/mason/packages/vscode-chrome-debug/out/src/chromeDebug.js' };
    }
    dap.adapters.node2 = {
      type = 'executable';
      command = 'node',
      args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' };
    }
    dap.configurations.typescriptreact = {
      {
        type = 'node2',
        request = 'launch',
        cwd = vim.fn.getcwd(),
        program = "${workspaceFolder}/node_modules/webpack-dev-server/bin/webpack-dev-server.js",
        sourceMaps = true,
        protocol = 'inspector',
        port = 9229,
        webRoot = '${workspaceFolder}',
        console = 'integratedTerminal',
        args = { '--inspect' }
      }
    }
    -- dap.configurations.typescriptreact = {
    --   {
    --     type = 'node2';
    --     request = 'attach';
    --     cwd = vim.fn.getcwd();
    --     sourceMaps = true;
    --     protocol = 'inspector';
    --     console = 'integratedTerminal';
    --   }
    -- }
    dap.configurations.typescript = {
      {
        type = 'node2',
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal'
      }
    }
  end
end

function M.dap_attach_debugger(dap)
  local type = ""
  local current_file = vim.fn.expand('%:t')

  vim.ui.input({ prompt = 'Enter dap type or testing framework (node2, chrome, jest, mocha, ...): ' },
    function(user_input)
      if user_input == 'q' or user_input == 'Q' then
        return
      end
      if current_file == 'package.json' or user_input == 'node2' then
        type = 'node2'
        -- '  "test": "npm run test-backend && npm run test-frontend",' will output 'test'
        local npm_script = string.match(vim.api.nvim_get_current_line(), '^%s*"(.*)":')
        -- run on script line in package.json. E.g. "test": "npm run test-backend && npm run test-frontend"
        require('toggleterm').exec_command('cmd="npm --node-options --inspect run ' .. npm_script .. '"')
      elseif current_file == string.match(current_file, '.*%.test%..*js$') or
          current_file == string.match(current_file, '.*%.spec%..*js$') or
          user_input == 'jest' then
        type = 'node2'
        -- "   it('will test something', () => {})" will output "will test something"
        local jest_test = string.match(vim.api.nvim_get_current_line(), '^%s*.*"(.*)",')
        -- run on describe or it line. E.g. it('will test something', () => {})
        require('toggleterm').exec_command([[cmd='npx --node-arg=--inspect jest -i % -t "]] .. jest_test .. [["']])
      elseif current_file == string.match(current_file, '^test-.*$') or user_input == 'mocha' then
        type = 'node2'
        -- "   it('will test something', () => {})" will output "will test something"
        local mocha_test = string.match(vim.api.nvim_get_current_line(), '^%s*.*"(.*)",')
        vim.ui.input({ prompt = 'Enter npm mocha script to attach to: ' }, function(mocha_script)
          -- run on describe or it line. E.g. it('will test something', () => {})
          require('toggleterm').exec_command([[cmd='npm --node-options --inspect run ]] ..
            mocha_script .. [[ -- --grep "]] .. mocha_test .. [["']])
        end
        )
      elseif current_file == string.match(current_file, '.*%.feature$') or user_input == 'cucumber' then
        type = 'node2'
        -- "   Scenario: Do something" will output "Do something"
        local cucumber_scenario = string.match(vim.api.nvim_get_current_line(), '^%s*.*: (.*)$')
        -- run on describe or it line. E.g. Scenario: Do something
        require('toggleterm').exec_command([[cmd='npx --node-arg=--inspect cucumber-js --name "]] ..
          cucumber_scenario .. [["']])
      else
        type = user_input
      end
      dap.run({
        type = type,
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector'
      })
    end
  )
end

return M
