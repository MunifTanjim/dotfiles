local color = require("config.color").dark

local mod = {}

function mod.get()
  ---@class nougat.color.gruvbox: nougat.color
  local gruvbox = {
    red = color.red,
    green = color.green,
    yellow = color.yellow,
    blue = color.blue,
    magenta = color.purple,
    cyan = color.aqua,

    orange = color.orange,

    bg = color.bg,
    bg0 = color.bg0,
    bg1 = color.bg1,
    bg2 = color.bg2,
    bg3 = color.bg3,
    bg4 = color.bg4,

    fg = color.fg,
    fg0 = color.fg0,
    fg1 = color.fg1,
    fg2 = color.fg2,
    fg3 = color.fg3,
    fg4 = color.fg4,

    accent = {
      red = color.accent.red,
      green = color.accent.green,
      yellow = color.accent.yellow,
      blue = color.accent.blue,
      magenta = color.accent.purple,
      cyan = color.accent.aqua,

      orange = color.accent.orange,

      bg = color.gray,
      fg = color.lightgray,
    },
  }

  return gruvbox
end

return mod
