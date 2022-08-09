vim.fn.sign_define("LightBulbSign", {
  text = "",
  texthl = "DiagnosticSignHint",
})

require("nvim-lightbulb").setup({
  sign = {
    enabled = true,
    priority = 10,
  },
  autocmd = {
    enabled = true,
    pattern = { "*" },
    events = { "CursorHold", "CursorHoldI" },
  },
})
