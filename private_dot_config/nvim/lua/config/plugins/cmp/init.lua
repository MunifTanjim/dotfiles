local cmp = require("cmp")
local lspkind = require("lspkind")

vim.o.completeopt = "menu,menuone,noselect"

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.register_source("copilot", require("config.plugins.cmp.cmp-copilot").new())

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
        copilot = "[ai]",
        nvim_lsp = "[lsp]",
        nvim_lua = "[vim]",
        path = "[path]",
        vsnip = "[snip]",
      },
    }),
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif vim.fn["vsnip#expandable"]() == 1 then
        feedkey("<Plug>(vsnip-expand)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      end
    end, {
      "i",
      "s",
    }),
    ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
    ["<Esc>"] = cmp.mapping.abort(),
    ["<C-j>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),
    ["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 3 },
    { name = "copilot", priority = 2 },
    { name = "vsnip", priority = 1 },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
