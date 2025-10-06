return {
  'mfussenegger/nvim-dap',             -- debugger
  dependencies = {
    'theHamsta/nvim-dap-virtual-text', -- debugger variable virtual text
    'microsoft/java-debug',            -- The Java Debug Server is an implementation of Visual Studio Code (VSCode) Debug Protocol
    'akinsho/toggleterm.nvim'
  },
  opts = {
    mappings = function()
      local function dap_attach_debugger(dap)
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
                type = 'java',
                request = 'attach',
                name = "Debug (Attach) - Remote",
                hostName = "127.0.0.1",
                port = 5005,
              })
            end
            if user_input == 'perl' then
              dap.run({
                type = 'perl',
                request = 'launch',
                name = 'Launch Perl',
                cwd = '${workspaceFolder}',
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/' .. vim.fn.expand('%'), 'file')
                end,
                -- Add other configuration options as required by your specific perl-debug-adapter
                -- e.g., 'args', 'cwd', 'env'
              })
            end
            if user_input == 'lua' then
              dap.run({
                type = "lua-local",
                request = "launch",
                name = "Debug",
                cwd = '${workspaceFolder}',
                program = {
                  lua = "lua",
                  file = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/' .. vim.fn.expand('%'), 'file')
                  end,

                }
              })
            end
            if user_input == 'cpp' or user_input == 'c++' or user_input == 'cppdbg' then
              dap.run({
                name = 'Attach to gdbserver :10000',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'gdb',
                miDebuggerServerAddress = 'localhost:10000',
                miDebuggerPath = '/usr/bin/gdb',
                cwd = '${workspaceFolder}',
                setupCommands = {
                  {
                    description = "Enable pretty-printing for gdb",
                    text = "-enable-pretty-printing",
                    ignoreFailures = true,
                  },
                  --{
                  --  description = "Set follow-fork-mode to child",
                  --  text = "set follow-fork-mode child",
                  --  ignoreFailures = false,
                  --}
                },
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/' .. vim.fn.expand('%'), 'file')
                end,
                sourceFileMap = {
                  -- "remote": "local"
                  ['/btmp/geninstall/genplusdev/h/source/'] = vim.fn.getcwd(),
                  ['/home/geninstall/source'] = vim.fn.getcwd()
                }
              })
              return
            end
            if current_file == string.match(current_file, '^.*%.cs$') or user_input == 'cs' or user_input == 'c#' or user_input == 'coreclr' or user_input == 'netcoredbg' then
              local dll_path = vim.fn.expand('%:h') .. '/bin/Debug/net8.0/' .. vim.fn.expand('%:h:t') .. '.dll'
              local current_test_file = string.match(current_file, '(.*).cs$');
              local test_method = string.match(vim.api.nvim_get_current_line(), '.*%s(.*)%(.*%)');
              require('toggleterm.terminal').Terminal:new({
                cmd = 'VSTEST_HOST_DEBUG=1 dotnet test ' ..
                    dll_path .. ' --filter ' .. current_test_file .. '.' .. test_method,
                hidden = false,
                close_on_exit = false,
                on_stdout = function(_, _, stdoutTable)
                  for _, value in pairs(stdoutTable) do
                    local processId = string.match(value, "Process Id%p%s(%d+)")
                    if processId ~= nil then
                      dap.run({
                        type = "coreclr",
                        name = "launch - netcoredbg",
                        request = "attach",
                        processId = processId,
                      })
                    end
                  end
                end
              }):spawn()
              return
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

      local dap = package.loaded.dap

      vim.keymap.set('n', '<Leader>db', ':DapToggleBreakpoint<CR>',
        {
          desc = 'nvim-dap - Press "' ..
              vim.g.mapleader .. '" + d + b to create or remove a breakpoint at the current line.'
        })
      vim.keymap.set('n', '<Leader>dlb', function() dap.list_breakpoints() end,
        {
          desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + l + b to list all breakpoints.'
        })
      vim.keymap.set('n', '<Leader>dcb', function() dap.clear_breakpoints() end,
        {
          desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + l + b to clear all breakpoints.'
        })
      vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        {
          desc = 'nvim-dap - Press "' ..
              vim.g.mapleader ..
              '" + d + B to guarantee overwriting of previous breakpoint. Otherwise, same as toggle_breakpoint.'
        })
      vim.keymap.set('n', '<Leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
        {
          desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + l + p to log message and set_breakpoint.'
        })
      vim.keymap.set('n', '<A-h>', ':DapContinue<CR>',
        {
          desc =
          'nvim-dap - Press Alt + h to resume the execution of an application if a debug session is active and a thread was stopped.'
        })
      vim.keymap.set('n', '<A-j>', ':DapStepOver<CR>',
        {
          desc = 'nvim-dap - Press Alt + j to request the debugee to step over a function or method.'
        })
      vim.keymap.set('n', '<A-k>', ':DapStepInto<CR>',
        {
          desc = 'nvim-dap - Press Alt + k to request the debugee to step into a function or method.'
        })
      vim.keymap.set('n', '<A-l>', ':DapStepOut<CR>',
        {
          desc = 'nvim-dap -  Press Alt + l to request the debugee to step out of a function or method.'
        })
      vim.keymap.set('n', '<leader>ds',
        ':lua local widgets=require("dap.ui.widgets");widgets.centered_float(widgets.scopes)<CR>',
        {
          desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + s view scopes'
        })
      vim.keymap.set({ 'n', 'v' }, '<leader>dh', ':lua require("dap.ui.widgets").hover()<CR>',
        {
          desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + h to view hover info'
        })
      vim.keymap.set('n', '<Leader>dr', ':DapToggleRepl<CR>',
        {
          desc = 'nvim-dap - Press "' ..
              vim.g.mapleader .. '" + d + r to opens the REPL if it is closed, otherwise closes it.'
        })
      vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end,
        {
          desc = 'nvim-dap - Press "' ..
              vim.g.mapleader .. '" + d + l to re-runs the last debug adapter / configuration that ran using dap.run().'
        })
      vim.keymap.set('n', '<leader>dk', function() dap.up() end,
        {
          desc = 'nvim-dap - Press "' .. vim.g.mapleader .. '" + d + k to go up in current stacktrace without stepping.'
        })
      vim.keymap.set('n', '<leader>dj', function() dap.down() end,
        {
          desc = 'nvim-dap - Press "' ..
              vim.g.mapleader .. '" + d + j to go down in current stacktrace without stepping.'
        })
      vim.keymap.set('n', '<leader>da', function() dap_attach_debugger(dap) end,
        {
          desc = 'nvim-dap - Press "' ..
              vim.g.mapleader ..
              '" d + a to attach a running debug adapter and then initialize it with the given dap-configuration.'
        })
    end,
  },
  config = function(_, opts)
    local is_dap, dap = pcall(require, 'dap')
    if not is_dap then
      print('dap is not installed')
      return
    end
    local is_nvim_dap_virtual_text, nvim_dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
    if not is_nvim_dap_virtual_text then
      print('nvim-dap-virtual-text is not installed')
      return
    end
    if is_dap and is_nvim_dap_virtual_text then
      nvim_dap_virtual_text.setup()
    end

    opts.mappings()
    dap.defaults.fallback.terminal_win_cmd = '20split new'
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#E06C75' })
    vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { ctermbg = 0, fg = '#ffaf00' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#88bf6a' })
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected',
      { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = 'DapBreakpointRejected' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = '', numhl = 'DapStopped' })

    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath("data") .. '/mason/packages/vscode-chrome-debug/out/src/chromeDebug.js' },
    }
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
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
    dap.configurations.javascript = {
      {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require 'dap.utils'.pick_process,
      },
    }
    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
      },
    }
    dap.adapters.java = function(callback)
      -- FIXME:
      -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
      -- The response to the command must be the `port` used below
      callback({
        type = 'server',
        host = '127.0.0.1',
        port = 5005,
      })
    end
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
    }
    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
      },
      {
        name = 'Attach to gdbserver :10000',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:10000',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
      },
      {
        name = "Attach to Docker",
        type = "cppdbg",
        request = "attach",
        MIMode = "gdb",
        processId = function()
          -- Find the process ID inside the container
          local output = vim.fn.system("docker exec <container_name> pidof <program_name>")
          return tonumber(output:match("%d+"))
        end,
        remote = {
          address = "localhost:10000",
          protocol = "tcp",
        },
        sourceLanguages = { "cpp" },
      }
    }

    dap.adapters.coreclr = {
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/bin/netcoredbg',
      args = { '--interpreter=vscode' }
    }
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          local dll_path = vim.fn.expand('%:h') .. '/bin/Debug/net8.0/' .. vim.fn.expand('%:h:t') .. '.dll'
          return vim.fn.input('Path to dll: ',
            dll_path,
            'file')
        end,
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        options = { detached = false }
      },
      {
        type = "coreclr",
        name = "attach - netcoredbg",
        request = "attach",
        processId = function()
          return vim.fn.input('Process Id: ')
        end
      },
    }

    dap.adapters.perl = {
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/bin/perl-debug-adapter',
      args = {}
    }
    dap.configurations.perl = {
      {
        type = 'perl',     -- This should match the 'type' defined by your perl-debug-adapter
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        -- Add other configuration options as required by your specific perl-debug-adapter
        -- e.g., 'args', 'cwd', 'env'
      },
    }
  end
}
