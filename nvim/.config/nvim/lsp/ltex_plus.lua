return {
  root_dir = function(bufnr)
    if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t') == 'prompt.md' then
      return nil
    end
    return vim.fn.getcwd()
  end,
}
