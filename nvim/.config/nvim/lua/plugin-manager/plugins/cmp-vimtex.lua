return {
  {
    'micangl/cmp-vimtex',
    ft = 'tex',
    dependencies = "hrsh7th/nvim-cmp",
    config = function()
      local is_cmp_vimtex, cmp_vimtex = pcall(require, 'cmp_vimtex')
      if not (is_cmp_vimtex) then
        print('cmp-vimtex is not installed')
        return
      end

      cmp_vimtex.setup({})

      local is_cmp, cmp = pcall(require, 'cmp')
      if not (is_cmp) then
        print('nvim-cmp is not installed')
        return
      end
      cmp.setup.filetype('tex', {
        sources = cmp.config.sources({
          { name = 'vimtex' },
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        }),
      })
    end,
  }
}
