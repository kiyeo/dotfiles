return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local is_codecompanion, codecompanion = pcall(require, 'codecompanion')
    if not is_codecompanion then
      print('codecompanion not found')
      return
    end
    codecompanion.setup({})
  end
}
