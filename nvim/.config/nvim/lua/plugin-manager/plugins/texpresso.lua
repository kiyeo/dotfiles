return {
  "let-def/texpresso.vim",
  init = function()
    local is_texpresso, texpresso = pcall(require, 'texpresso')
    if not (is_texpresso) then
      print("texpresso not found")
      return
    end

    texpresso.texpresso_path = '/home/leo/texpresso/build/texpresso'

    vim.api.nvim_create_user_command('TeXpressoSync',
      function()
        local buf = 0
        local path = vim.api.nvim_buf_get_name(buf)
        texpresso.send("open", path, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
      end,
      {
      }
    )
  end
}
