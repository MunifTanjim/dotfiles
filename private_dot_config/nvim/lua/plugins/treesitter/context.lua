local u = require("config.utils")

local ts_ctx = require("treesitter-context")

ts_ctx.setup({
  enable = true,
  max_lines = 3,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "cursor",
  zindex = 20,
})

u.set_keymaps("n", {
  {
    "<Leader>tsc",
    "<Cmd>TSContextToggle<CR>",
    "[treesitter] toggle context",
  },
  {
    "gK",
    function()
      ts_ctx.go_to_context()
    end,
    "[treesitter] toggle context",
  },
})
