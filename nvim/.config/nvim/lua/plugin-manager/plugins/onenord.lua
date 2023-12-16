return {
  -- colorscheme
  'rmehri01/onenord.nvim', -- main theme
  lazy = false,
  priority = 1000,
  opts = {
    custom_highlights = {
      BufferLineIndicatorSelected = { fg = "#88c0d0", bg = "#2e3440" },
      BufferLineFill = { fg = "#ECEFF4", bg = "#242932" },
      GitSignsChange = { fg = '#d08770' },
      GitSignsChangeNr = { fg = '#d08770' },
      GitSignsChangeLn = { fg = '#d08770' }
    }
  }
}
