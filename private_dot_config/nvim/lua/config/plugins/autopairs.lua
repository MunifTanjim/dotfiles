local autopairs = require("nvim-autopairs")

autopairs.setup({
  enable_check_bracket_line = false,
})

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done({
    map_char = {
      sh = "",
    },
  })
)
