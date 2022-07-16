vim.o.exrc = false

require("exrc").setup()

local local_config = {
  lsp = {
    format_on_save = true,
  },
}

return local_config
