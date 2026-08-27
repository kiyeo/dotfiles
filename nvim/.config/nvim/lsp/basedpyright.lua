return {
  init_options = { documentFormatting = true },
  settings = {
    basedpyright = {
      -- Options: "off", "basic", "standard", "strict", "all"
      typeCheckingMode = "standard",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}
