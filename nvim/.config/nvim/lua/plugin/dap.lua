local mappings = require('plugin.mappings')

local is_dap, dap = pcall(require, 'dap')
if is_dap then
  mappings.nvim_dap(dap)
  dap.defaults.fallback.terminal_win_cmd = '20split new'
  vim.highlight.create('DapBreakpoint', { ctermbg = 0, guifg = '#E06C75', guibg = 0 }, false)
  vim.highlight.create('DapBreakpointRejected', { ctermbg = 0, guifg = '#61afef', guibg = 0 }, false)
  vim.highlight.create('DapStopped', { ctermbg = 0, guifg = '#E06C75', guibg = 0 }, false)
  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointRejected',
    { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = 'DapBreakpointRejected' })
  vim.fn.sign_define('DapStopped', { text = '卑', texthl = 'DapStopped', linehl = '', numhl = 'DapStopped' })

  dap.adapters.node2 = {
    type = 'executable';
    command = 'node',
    args = { vim.fn.stdpath "data" .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' };
  }
  dap.configurations.typescriptreact = {
    {
      type = 'chrome',
      request = 'attach',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      port = 9222,
      webRoot = '${workspaceFolder}'
    }
  }
  dap.configurations.typescript = {
    {
      type = 'node2';
      request = 'attach';
      cwd = vim.fn.getcwd();
      sourceMaps = true;
      protocol = 'inspector';
      console = 'integratedTerminal';
    }
  }
end
