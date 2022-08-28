local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local clang_format = null_ls.builtins.formatting.clang_format.with({
  condition = function(utils)
    return utils.root_has_file({ ".clang-format" })
  end,
  runtime_condition = helpers.cache.by_bufnr(function(params)
    if vim.fn.filereadable(".clang-format-ignore") == 0 then
      return false
    end

    local ignore_file = ".clang-format-ignore"
    local filename = vim.fn.fnamemodify(params.bufname, ":.")
    local find_command = string.format("fd --has-results --ignore-file %s --full-path '%s' .", ignore_file, filename)
    return os.execute(find_command) == 0
  end),
})

---@diagnostic disable-next-line: redundant-parameter
null_ls.setup({
  sources = {
    clang_format,
    null_ls.builtins.diagnostics.luacheck.with({
      condition = function(utils)
        return utils.root_has_file({ ".luacheckrc" })
      end,
    }),
    null_ls.builtins.formatting.stylua,
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
