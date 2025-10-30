return {
  'nvim-lualine/lualine.nvim', -- statusline
  event = "VeryLazy",
  opts = function()
    local onenord = require('lualine.themes.onenord')
    -- transparency
    onenord.normal.c.bg = "NONE"
    return {
      options = {
        theme = onenord
      },
    }
  end
}
