return {
  -- open buffer tab style
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = {
    'kyazdani42/nvim-web-devicons' -- file icons
  },
  opts = {
    options = {
      tab_size = 25,
      sort_by = 'insert_at_end',
      offsets = { { filetype = 'NvimTree', text = '', padding = 1 }, { filetype = 'toggleterm', text = '' } },
      separator_style = { '', '' }
    },
    highlights = {
      buffer_selected = {
        bold = true
      },
      duplicate_selected = {
        bold = true
      },
      duplicate_visible = {
        bold = true
      },
      duplicate = {
        bold = true
      },
    }
  },
}
