return {
  -- parser generator tool and an incremental parsing library
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring', -- embedded language commenting
  },
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'cpp',
      'css',
      'html',
      'javascript',
      'jsdoc',
      'latex',
      'lua',
      'markdown',
      'rust',
      'toml',
      'typescript',
      'yaml',
      'java'
    },
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
  },
  config = function(_, opts)
    vim.g.skip_ts_context_commentstring_module = true
    require("nvim-treesitter.configs").setup(opts)
  end
}
