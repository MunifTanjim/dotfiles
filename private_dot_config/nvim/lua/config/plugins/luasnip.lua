local luasnip = require("luasnip")
local types = require("luasnip.util.types")

luasnip.config.setup({
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxOrange" } },
        hl_mode = "combine",
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { "●", "GruvboxBlue" } },
        hl_mode = "combine",
      },
    },
  },
  region_check_events = "CursorMoved",
  update_events = "TextChanged,TextChangedI",
  -- this does not affect lsp-snippets
  load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
    javascriptreact = { "javascript" },
    typescript = { "javascript" },
    typescriptreact = { "javascript", "typescript", "javascriptreact" },
  }),
})

local lsp_snippets_path = vim.fn.resolve(vim.fn.stdpath("config") .. "/snippets/lsp")
if vim.fn.isdirectory(lsp_snippets_path) == 0 then
  print("[config] Missing LSP Snippets")
else
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = {
      lsp_snippets_path,
    },
  })
end

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if luasnip.jumpable(-1) then
    return "<Plug>luasnip-jump-prev"
  end

  return "<C-h>"
end, { desc = "[snip] jump prev", expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if luasnip.expand_or_jumpable() then
    return "<Plug>luasnip-expand-or-jump"
  end

  return "<C-l>"
end, { desc = "[snip] expand or jump next", expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if luasnip.expandable() then
    return "<Plug>luasnip-expand-snippet"
  end

  if luasnip.choice_active() then
    return "<Plug>luasnip-next-choice"
  end

  return "<C-j>"
end, { desc = "[snip] expand or next choice", expr = true, silent = true, remap = true })
