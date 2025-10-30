return {
  'numToStr/Comment.nvim', -- comment code
  event = 'BufReadPre',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring', -- embedded language commenting
  },
  opts = {
    pre_hook = function(ctx)
      local U = require('Comment.utils')

      local location = nil
      if ctx.ctype == U.ctype.block then
        location = require('ts_context_commentstring.utils').get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require('ts_context_commentstring.utils').get_visual_start_location()
      end

      return require('ts_context_commentstring.internal').calculate_commentstring {
        key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
        location = location,
      }
    end
  },
  config = function()
    local is_comment, comment = pcall(require, 'Comment')
    if not is_comment then
      print('comment is not installed')
      return
    end
    comment.setup()
  end
}
