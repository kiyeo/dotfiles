return {
  init_options = { documentFormatting = true },
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      hover = true,
      completion = true,
      customTags = {
        '!Base64 scalar',
        '!Cidr scalar',
        '!And sequence',
        '!Equals sequence',
        '!If sequence',
        '!Not sequence',
        '!Or sequence',
        '!Condition scalar',
        '!FindInMap sequence',
        '!GetAtt scalar',
        '!GetAZs scalar',
        '!ImportValue scalar',
        '!Join sequence',
        '!Select sequence',
        '!Split sequence',
        '!Sub scalar',
        '!Transform mapping',
        '!Ref scalar',
      }
    }
  }
}
