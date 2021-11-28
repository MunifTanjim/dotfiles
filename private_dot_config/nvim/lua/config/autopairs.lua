local autopairs = require("nvim-autopairs")

autopairs.setup({
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = false,
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  enable_afterquote = true,
  enable_check_bracket_line = true,
  check_ts = false,
  map_bs = true,
  map_c_w = false,
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
