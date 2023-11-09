local plugins = {
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = {
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
    },
    init = function()
      require("config.utils").set_keymaps("n", {
        {
          "<Leader>trn",
          ":Neotest run<CR>",
          "[test] run nearest",
        },
        {
          "<Leader>trf",
          ":Neotest run file<CR>",
          "[test] run file",
        },
      })
    end,
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-plenary"),
          require("neotest-rust"),
        },
        icons = {
          running_animated = { "⠋", "⠙", "⠚", "⠞", "⠖", "⠦", "⠴", "⠲", "⠳", "⠓" },
          passed = "",
          running = "",
          failed = "",
          skipped = "",
          unknown = "",
          non_collapsible = "─",
          collapsed = "─",
          expanded = "╮",
          child_prefix = "├",
          final_child_prefix = "╰",
          child_indent = "│",
          final_child_indent = " ",
        },
        highlights = {
          passed = "DiagnosticSignHint",
          running = "DiagnosticSignWarn",
          failed = "DiagnosticSignError",
          skipped = "DiagnosticSignInfo",
        },
      })
    end,
  },
}

return plugins
