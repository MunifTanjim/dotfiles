vim.o.exrc = false

require("exrc").setup()

local local_config = {
  lsp = {
    format_on_save = true,
    tsserver = {
      ignore_diagnostics_by_code = {},
      ignore_diagnostics_by_severity = {},
    },
  },
}

return local_config
