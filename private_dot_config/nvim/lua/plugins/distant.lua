return {
  "chipsenkbeil/distant.nvim",
  config = function()
    require("distant").setup({
      ["*"] = require("distant.settings").chip_default(),
    })
  end,
}
