return {
  {
    'micangl/cmp-vimtex',
    ft = 'tex',
    config = function()
      local is_cmp_vimtex, cmp_vimtex = pcall(require, 'cmp_vimtex')
      if not (is_cmp_vimtex) then
        print('nvim-cmp is not installed')
        return
      end

      cmp_vimtex.setup({})
    end,
  }
}
