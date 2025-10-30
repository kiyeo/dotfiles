return {
  'windwp/nvim-autopairs',
  dependencies = {
    'hrsh7th/nvim-cmp'
  },
  config = function()
    local is_nvim_autopairs, nvim_autopairs = pcall(require, 'nvim-autopairs')
    if not is_nvim_autopairs then
      print('nvim-autopairs is not installed')
      return
    end
    nvim_autopairs.setup({})

    local is_cmp_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    if not is_cmp_autopairs then
      print('nvim-autopairs.completion.cmp is not installed')
      return
    end

    local is_cmp, cmp = pcall(require, 'cmp')
    if not (is_cmp) then
      print('nvim-cmp is not installed')
      return
    end

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
