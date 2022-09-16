vim.fn.sign_define("LightBulbSign", {
  text = "",
  texthl = "DiagnosticSignHint",
})

local lightbulb = require("nvim-lightbulb")

lightbulb.setup({
  sign = {
    enabled = true,
    priority = 10,
  },
})

-- disabled because of unusual offset_encoding of `clangd` server causing warning in:
-- https://github.com/neovim/neovim/blob/88c32b5/runtime/lua/vim/lsp/util.lua#L1882-L1886
local is_disabled_filetype = {
  c = true,
  cpp = true,
}

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("LightBulb", { clear = true }),
  desc = "lua require('nvim-lightbulb').update_lightbulb()",
  callback = function(params)
    if not is_disabled_filetype[vim.bo[params.buf].filetype] then
      lightbulb.update_lightbulb()
    end
  end,
})
