return {
  'norcalli/nvim-colorizer.lua', -- color highlighter
  config = function()
    local is_colorizer, colorizer = pcall(require, 'colorizer')
    if is_colorizer then
      colorizer.setup({ '*' }, {
        RRGGBBAA = true,
        css = true,
      })
    end
  end
}
