local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer = require('packer')

local config_compile_path = vim.fn.stdpath('data') .. '/site/pack/loader/start/packer/plugin/packer_compuled.lua'

vim.cmd [[packadd packer.nvim]]
packer.init({
  compile_path = config_compile_path
})

packer.startup({
  function(use)
    use 'wbthomason/packer.nvim'

    -- colorscheme
    -- use 'glepnir/zephyr-nvim'
    use 'rmehri01/onenord.nvim'

    -- language server protocol
    use {
      'williamboman/nvim-lsp-installer',
      'neovim/nvim-lspconfig'
    }

    -- snippet engine
    use 'L3MON4D3/LuaSnip'

    -- completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'

    -- fuzzy finder
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- parser generator tool and an incremental parsing library
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    }

    use 'mhartington/formatter.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'mfussenegger/nvim-dap'
    use 'tpope/vim-commentary'
    use 'kassio/neoterm'

    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    compile_path = config_compile_path
  }
})

vim.cmd('source ' .. config_compile_path)
require 'plugin.settings'
