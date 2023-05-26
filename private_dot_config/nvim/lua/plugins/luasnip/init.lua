local plugin = {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
  },
  event = "InsertEnter",
}

function plugin.config()
  local u = require("config.utils")
  local ls = require("luasnip")
  local types = require("luasnip.util.types")

  local ft_extend_map = {
    javascriptreact = { "javascript" },
    typescript = { "javascript" },
    typescriptreact = { "javascript", "typescript", "javascriptreact" },
  }

  for ft, extend_fts in pairs(ft_extend_map) do
    ls.filetype_extend(ft, extend_fts)
  end

  ls.config.setup({
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
    load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft(ft_extend_map),
  })

  local lsp_snippets_path = vim.fn.resolve(vim.fn.stdpath("config") .. "/snippets/lsp")
  if vim.fn.isdirectory(lsp_snippets_path) == 0 then
    print("[config] Missing LSP Snippets")
  else
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { lsp_snippets_path },
    })
  end

  local luasnip_snippets_path = vim.fn.resolve(vim.fn.stdpath("config") .. "/snippets/luasnip")
  if vim.fn.isdirectory(luasnip_snippets_path) == 0 then
    print("[config] Missing LuaSnip Snippets")
  else
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { luasnip_snippets_path },
    })
  end

  u.set_keymaps({ "i", "s" }, {
    {
      "<C-h>",
      function()
        if ls.jumpable(-1) then
          return "<Plug>luasnip-jump-prev"
        end

        return "<C-h>"
      end,
      "[snip] jump prev",
    },
    {
      "<C-l>",
      function()
        if ls.expand_or_jumpable() then
          return "<Plug>luasnip-expand-or-jump"
        end

        return "<C-l>"
      end,
      "[snip] expand or jump next",
    },
    {
      "<C-j>",
      function()
        if ls.expandable() then
          return "<Plug>luasnip-expand-snippet"
        end

        if ls.choice_active() then
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

  vim.api.nvim_create_user_command("LuaSnipEdit", function()
    require("luasnip.loaders").edit_snippet_files({})
  end, {})
end

return plugin
