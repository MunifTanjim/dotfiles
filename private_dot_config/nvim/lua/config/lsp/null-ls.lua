local exrc = require("config.exrc")

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
  },
  on_attach = function(client, bufnr)
    local map_opts = { noremap = true, silent = true }

    if client.resolved_capabilities.document_formatting then
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", map_opts)

      if exrc.lsp.format_on_save then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
      end
    end

    if client.resolved_capabilities.document_range_formatting then
      vim.api.nvim_buf_set_keymap(bufnr, "x", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting({})<CR>", map_opts)
    end
  end,
})

local eslint = require("eslint")
eslint.setup({
  bin = "eslint_d",
})

local prettier = require("prettier")
prettier.setup({
  bin = "prettier",
})
