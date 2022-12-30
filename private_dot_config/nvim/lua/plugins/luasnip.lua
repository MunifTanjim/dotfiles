local plugin = {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
  },
  build = "make install_jsregexp",
}

function plugin.config()
  local u = require("config.utils")
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

  u.set_keymaps({ "i", "s" }, {
    {
      "<C-h>",
      function()
        if luasnip.jumpable(-1) then
          return "<Plug>luasnip-jump-prev"
        end

        return "<C-h>"
      end,
      "[snip] jump prev",
    },
    {
      "<C-l>",
      function()
        if luasnip.expand_or_jumpable() then
          return "<Plug>luasnip-expand-or-jump"
        end

        return "<C-l>"
      end,
      "[snip] expand or jump next",
    },
    {
      "<C-j>",
      function()
        if luasnip.expandable() then
          return "<Plug>luasnip-expand-snippet"
        end

        if luasnip.choice_active() then
          return "<Plug>luasnip-next-choice"
        end

        return "<C-j>"
      end,
      "[snip] expand or next choice",
      remap = true,
    },
  }, {
    expr = true,
  })
end

return plugin
