local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
    use 'wbthomason/packer.nvim'

    -- colorscheme
    use "rmehri01/onenord.nvim" -- main theme
    use 'nvim-lualine/lualine.nvim' -- statusline

    -- language server protocol
    use {
      'williamboman/nvim-lsp-installer',
      'neovim/nvim-lspconfig'
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
      'David-Kunz/cmp-npm'
    }

    -- fuzzy finder
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- parser generator tool and an incremental parsing library
    use {
      'nvim-treesitter/nvim-treesitter',
      run = { function() vim.cmd(':TSUpdate') end }
    }

    -- utilities
    use {
      'mhartington/formatter.nvim', -- format code
      'lewis6991/gitsigns.nvim',    -- git decoration and actions
      'mfussenegger/nvim-dap',      -- debugger
      'tpope/vim-commentary',       -- comment code
      'kassio/neoterm',             -- terminal
      'godlygeek/tabular'           -- column align text. E.g :Tabularize /--
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
require 'plugin.settings'
