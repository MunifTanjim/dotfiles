local null_ls = require("null-ls")

---@diagnostic disable-next-line: redundant-parameter
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.luacheck.with({
      condition = function(utils)
        return utils.root_has_file({ ".luacheckrc" })
      end,
    }),
  },
  on_attach = function(client, bufnr)
    local map_opts = { buffer = bufnr, silent = true }

    vim.keymap.set("n", "<Leader>f", require("config.lsp.formatting").format, map_opts)
    vim.keymap.set("x", "<Leader>f", require("config.lsp.formatting").range_format, map_opts)

    vim.cmd("autocmd BufWritePre <buffer> lua require('config.lsp.formatting').format()")
  end,
})

require("eslint").setup({
  bin = "eslint_d",
})

require("prettier").setup({
  bin = "prettier",
})
