local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
  vim.cmd([[packadd packer.nvim]])
end

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  print("Packer not found")
  return
end

local config_compile_path = vim.fn.stdpath('data') .. '/site/pack/loader/start/packer/plugin/packer_compuled.lua'

packer.init({
  compile_path = config_compile_path
})

packer.startup({
  function(use)
    use 'wbthomason/packer.nvim' -- package manager

    -- colorscheme
    use "rmehri01/onenord.nvim" -- main theme
    use 'nvim-lualine/lualine.nvim' -- statusline

    -- language server protocol
    use {
      'neovim/nvim-lspconfig', -- configurations for Nvim LSP
      'williamboman/mason.nvim', -- manage LSP servers, DAP servers, linters, and formatters
      'williamboman/mason-lspconfig.nvim', -- extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
      'lukas-reineke/lsp-format.nvim'
    }

    -- parser generator tool and an incremental parsing library
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.cmd(':TSUpdate') end
    }

    -- snippet engine
    use 'L3MON4D3/LuaSnip'

    -- completion
    use {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'David-Kunz/cmp-npm',
      'hrsh7th/cmp-nvim-lua' -- lua vim.lsp.* API completion
    }

    -- file explorer
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons' -- file icons
    }

    -- open buffer tab style
    use {
      'akinsho/bufferline.nvim',
      tag = "v2.*",
      requires = 'kyazdani42/nvim-web-devicons' -- file icons
    }

    -- fuzzy finder
    use {
      'nvim-telescope/telescope.nvim',
      requires = 'nvim-lua/plenary.nvim'
    }

    -- utilities

    use {
      'mfussenegger/nvim-dap', -- debugger
      'theHamsta/nvim-dap-virtual-text' -- debugger variable virtual text
    }

    use {
      'lewis6991/gitsigns.nvim', -- git decoration and actions
      'numToStr/Comment.nvim', -- comment code
      'JoosepAlviste/nvim-ts-context-commentstring', -- embedded language commenting
      'akinsho/toggleterm.nvim', -- terminal
      'godlygeek/tabular', -- column align text. E.g :Tabularize /--
      'norcalli/nvim-colorizer.lua' -- color highlighter
    }

    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    compile_path = config_compile_path
  }
})

pcall(vim.cmd, 'source' .. config_compile_path)
require('plugin.settings')
require('plugin.lsp_config').mason_lspconfig()
require('plugin.cmp').cmp()
require('plugin.dap').dap_configuration()
