local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local u = require("plugins.lsp.utils")

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

local function has_no_ruff_config(utils)
  return not utils.has_file({ "./ruff.toml" }) and not utils.root_has_file({ "ruff.toml" })
end

---@diagnostic disable-next-line: redundant-parameter
null_ls.setup({
  sources = {
    -- c
    clang_format,
    -- python
    require("none-ls.diagnostics.flake8").with({
      condition = has_no_ruff_config,
    }),
    null_ls.builtins.formatting.black.with({
      condition = has_no_ruff_config,
    }),
    null_ls.builtins.formatting.isort.with({
      condition = has_no_ruff_config,
    }),
    -- lua
    require("none-ls-luacheck.diagnostics.luacheck").with({
      condition = function(utils)
        return utils.root_has_file({ ".luacheckrc" })
      end,
    }),
    null_ls.builtins.formatting.stylua,
  },
  on_attach = function(client, bufnr)
    u.setup_keymaps(client, bufnr)
    u.setup_format_on_save(client, bufnr)
  end,
})

require("eslint").setup({
  bin = vim.g.eslint_bin or "eslint_d",
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type",
  },
})

require("prettier").setup({
  bin = "prettierd",
})
