local plugin = {
  "MunifTanjim/exrc.nvim",
}

function plugin.config()
  vim.o.exrc = false
  require("exrc").setup()
end

return plugin
