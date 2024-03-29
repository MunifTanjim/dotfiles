local plugin = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "onsails/lspkind-nvim",
  },
  event = "InsertEnter",
}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function plugin.config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")

  vim.o.completeopt = "menu,menuone,noselect"

  ---@diagnostic disable-next-line: redundant-parameter
  cmp.setup({
    completion = {
      autocomplete = false,
      completeopt = vim.o.completeopt,
    },
    experimental = {
      ghost_text = true,
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        menu = {
          buffer = "[buf]",
          luasnip = "[snip]",
          nvim_lsp = "[lsp]",
          nvim_lua = "[vim]",
          path = "[path]",
        },
      }),
    },
    mapping = {
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        elseif cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif has_words_before() then
          cmp.complete({ reason = cmp.ContextReason.Manual })
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Esc>"] = cmp.mapping.abort(),
      ["<C-]>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.close()
        elseif require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").dismiss()
        else
          fallback()
        end
      end),
      ["<C-Down>"] = cmp.mapping.scroll_docs(3),
      ["<C-Up>"] = cmp.mapping.scroll_docs(-3),
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 3 },
      { name = "luasnip", priority = 1 },
    }, {
      { name = "buffer" },
    }),
  })

  local cmdline_mapping = cmp.mapping.preset.cmdline({
    ["<CR>"] = {
      c = cmp.mapping.confirm({ select = true }),
    },
    ["<Esc>"] = {
      c = function()
        if not cmp.close() then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
        end
      end,
    },
  })

  cmp.setup.cmdline("/", {
    mapping = cmdline_mapping,
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.event:on("menu_opened", function()
    vim.api.nvim_buf_set_var(0, "copilot_suggestion_hidden", true)
  end)

  cmp.event:on("menu_closed", function()
    vim.api.nvim_buf_set_var(0, "copilot_suggestion_hidden", false)
  end)
end

return plugin
