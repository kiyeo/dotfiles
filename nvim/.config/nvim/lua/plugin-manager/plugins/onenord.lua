return {
  -- colorscheme
  'rmehri01/onenord.nvim', -- main theme
  lazy = false,
  priority = 1000,
  opts = function()
    local border = {
      { '╭', "FloatBorder" },
      { '─', "FloatBorder" },
      { '╮', "FloatBorder" },
      { '│', "FloatBorder" },
      { '╯', "FloatBorder" },
      { '─', "FloatBorder" },
      { '╰', "FloatBorder" },
      { '│', "FloatBorder" },
    }
    -- To instead override globally
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    return {
      custom_highlights = {
        BufferLineIndicatorSelected = { fg = "#88c0d0", bg = "#2e3440" },
        BufferLineFill = { fg = "#ECEFF4", bg = "#242932" },
        GitSignsChange = { fg = '#d08770' },
        GitSignsChangeNr = { fg = '#d08770' },
        GitSignsChangeLn = { fg = '#d08770' },
      },
      -- transparency
      disable = {
        background = true,       -- Disable setting the background color
        float_background = true, -- Disable setting the background color for floating windows
        cursorline = true,       -- Disable the cursorline
      }
    }
  end
}
