local plugin = {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    highlight = {
      backdrop = false,
    },
    label = {
      style = "eol",
    },
    modes = {
      char = {
        highlight = {
          backdrop = false,
          groups = {
            label = "FlashMatch",
          },
        },
      },
      search = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)

    local augroup = vim.api.nvim_create_augroup("plugins.flash", { clear = true })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      group = augroup,
      pattern = "/",
      callback = function()
        require("flash").toggle(false)
      end,
    })
  end,
  keys = {
    {
      "<M-s>",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "[flash] search",
    },
    {
      "<M-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "[flash] toggle search",
    },
  },
}

return plugin
