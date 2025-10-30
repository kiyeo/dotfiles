return {
  cmd = { 'csharp-ls' },
  filetypes = { 'cs', 'razor', 'csproj' },
  root_dir = require('lspconfig').util.root_pattern('*.sln', '*.csproj'),
}
