return {
  'github/copilot.vim',
  config = function()
    local is_copilot, copilot = pcall(require, 'copilot')
    if not is_copilot then
      print('copilot not found')
      return
    end
    copilot.setup({})
  end
}
