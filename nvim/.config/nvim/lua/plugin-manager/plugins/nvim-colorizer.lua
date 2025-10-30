return {
  'norcalli/nvim-colorizer.lua', -- color highlighter
  config = function()
    local is_colorizer, colorizer = pcall(require, 'colorizer')
    if not (is_colorizer) then
      print('colorizer is not installed')
      return
    end

    colorizer.setup({ '*' }, {
      RRGGBBAA = true,
      css = true,
    })
  end
}
