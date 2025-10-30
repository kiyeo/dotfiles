local is_texpresso, texpresso = pcall(require, 'texpresso')
if not is_texpresso then
  print('texpresso is not installed')
  return
end

texpresso.attach()
local autocmd = vim.api.nvim_create_autocmd
autocmd({ 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('texpressoGroup', {}),
  callback = function()
    vim.cmd('TeXpressoSync')
  end
})
