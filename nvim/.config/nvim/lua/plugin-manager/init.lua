local install_path = vim.fn.stdpath('data') .. '/site/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(install_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    install_path,
  })
end
vim.opt.rtp:prepend(install_path)

local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  print('lazy is not installed')
  return
end

lazy.setup('plugin-manager.plugins')
