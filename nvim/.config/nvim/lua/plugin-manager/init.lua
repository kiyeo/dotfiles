local install_path = vim.fn.stdpath('data') .. '/site/lazy/lazy.nvim'
if not vim.loop.fs_stat(install_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    install_path,
  })
end
vim.opt.rtp:prepend(install_path)

local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  print("Lazy not found")
  return
end

lazy.setup({
  import = "plugin-manager.plugins"
})
--'mfussenegger/nvim-jdtls', -- extensions for the built-in Language Server Protocol support in Neovim (>= 0.6.0) for eclipse.jdt.ls.
