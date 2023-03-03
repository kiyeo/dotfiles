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
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#E06C75' })
    vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { ctermbg = 0, fg = '#ffaf00' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#88bf6a' })
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
        skipFiles = { "<node_internals>/**", "node_modules" }
      }
    }
    dap.configurations.java = {
      {
        type = 'java';
        request = 'attach';
        name = "Debug (Attach) - Remote";
        hostName = "127.0.0.1";
        port = 5005;
      },
    }
    dap.adapters.java = function(callback)
      -- FIXME:
      -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
      -- The response to the command must be the `port` used below
      callback({
        type = 'server';
        host = '127.0.0.1';
        port = 5005;
      })
    end
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
      if user_input == 'java' then
        -- require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        -- require('jdtls.dap').setup_dap_main_class_configs()
        dap.run({
          type = 'java';
          request = 'attach';
          name = "Debug (Attach) - Remote";
          hostName = "127.0.0.1";
          port = 5005;
        })
      end
      local npm_7 = '--node-options=--inspect'
      local npm_6 = '--node-arg=--inspect'
      type = 'node2'
      if current_file == 'package.json' or user_input == 'node2' then
        local npm_script = string.match(vim.api.nvim_get_current_line(), '^%s*"(.*)":')
        require('toggleterm').exec_command('cmd="npm ' .. npm_7 .. ' run ' .. npm_script .. '"')
      elseif current_file == string.match(current_file, '.*%.test%..*$') or
          current_file == string.match(current_file, '.*%.spec%..*$') or
          user_input == 'jest' then
        local jest_test = string.match(vim.api.nvim_get_current_line(), '^%s*.*"(.*)",')
        require('toggleterm').exec_command([[cmd='npx ]] .. npm_7 .. [[ jest -i % -t "]] .. jest_test .. [["']])
      elseif current_file == string.match(current_file, '^test-.*$') or user_input == 'mocha' then
        local mocha_test = string.match(vim.api.nvim_get_current_line(), '^%s*.*"(.*)",')
        vim.ui.input({ prompt = 'Enter npm mocha script to attach to: ' }, function(mocha_script)
          require('toggleterm').exec_command([[cmd='npm ]] .. npm_7 .. [[ run ]] ..
            mocha_script .. [[ -- --grep "]] .. mocha_test .. [["']])
        end
        )
      elseif current_file == string.match(current_file, '.*%.feature$') or user_input == 'cucumber' then
        local cucumber_scenario = string.match(vim.api.nvim_get_current_line(), '^%s*.*: (.*)$')
        require('toggleterm').exec_command([[cmd='npx ]] .. npm_7 .. [[ cucumber-js --name "]] ..
          cucumber_scenario .. [["']])
      else
        type = user_input
      end
      dap.run({
        type = type,
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = { "<node_internals>/**", "node_modules" }
      })
    end
  )
end

return M
