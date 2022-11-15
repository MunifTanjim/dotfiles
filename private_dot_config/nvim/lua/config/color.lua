local function get_gruvbox()
  local gruvbox = {
    dark0_hard = "#1d2021",
    dark0 = "#282828",
    dark0_soft = "#32302f",
    dark1 = "#3c3836",
    dark2 = "#504945",
    dark3 = "#665c54",
    dark4 = "#7c6f64",

    light0_hard = "#f9f5d7",
    light0 = "#fbf1c7",
    light0_soft = "#f2e5bc",
    light1 = "#ebdbb2",
    light2 = "#d5c4a1",
    light3 = "#bdae93",
    light4 = "#a89984",

    bright = {
      gray = "#a89984",
      red = "#fb4934",
      green = "#b8bb26",
      yellow = "#fabd2f",
      blue = "#83a598",
      purple = "#d3869b",
      aqua = "#8ec07c",
      orange = "#f38019",
    },

    neutral = {
      gray = "#928374",
      red = "#cc241d",
      green = "#98971a",
      yellow = "#d79921",
      blue = "#458588",
      purple = "#b16286",
      aqua = "#689d6a",
      orange = "#d65d0e",
    },

    faded = {
      gray = "#7c6f64",
      red = "#9d0006",
      green = "#79740e",
      yellow = "#b57614",
      blue = "#076678",
      purple = "#8f3f71",
      aqua = "#427b58",
      orange = "#af3a03",
    },
  }

  gruvbox.dark = {
    bg = gruvbox.dark0,
    bg0_h = gruvbox.dark0_hard,
    bg0 = gruvbox.dark0,
    bg0_s = gruvbox.dark0_soft,
    bg1 = gruvbox.dark1,
    bg2 = gruvbox.dark2,
    bg3 = gruvbox.dark3,
    bg4 = gruvbox.dark4,

    gray = gruvbox.neutral.gray,

    fg = gruvbox.light1,
    fg0 = gruvbox.light0,
    fg1 = gruvbox.light1,
    fg2 = gruvbox.light2,
    fg3 = gruvbox.light3,
    fg4 = gruvbox.light4,

    lightgray = gruvbox.light4,

    red = gruvbox.bright.red,
    green = gruvbox.bright.green,
    yellow = gruvbox.bright.yellow,
    blue = gruvbox.bright.blue,
    purple = gruvbox.bright.purple,
    aqua = gruvbox.bright.aqua,
    orange = gruvbox.bright.orange,

    accent = {
      red = gruvbox.neutral.red,
      green = gruvbox.neutral.green,
      yellow = gruvbox.neutral.yellow,
      blue = gruvbox.neutral.blue,
      purple = gruvbox.neutral.purple,
      aqua = gruvbox.neutral.aqua,
      orange = gruvbox.neutral.orange,
    },
  }

  gruvbox.light = {
    bg = gruvbox.light0,
    bg0_h = gruvbox.light0_hard,
    bg0 = gruvbox.light0,
    bg0_s = gruvbox.light0_soft,
    bg1 = gruvbox.light1,
    bg2 = gruvbox.light2,
    bg3 = gruvbox.light3,
    bg4 = gruvbox.light4,

    gray = gruvbox.neutral.gray,

    fg = gruvbox.dark1,
    fg0 = gruvbox.dark0,
    fg1 = gruvbox.dark1,
    fg2 = gruvbox.dark2,
    fg3 = gruvbox.dark3,
    fg4 = gruvbox.dark4,

    darkgray = gruvbox.dark4,

    red = gruvbox.faded.purple,
    green = gruvbox.faded.green,
    yellow = gruvbox.faded.yellow,
    blue = gruvbox.faded.blue,
    purple = gruvbox.faded.purple,
    aqua = gruvbox.faded.aqua,
    orange = gruvbox.faded.orange,

    accent = {
      red = gruvbox.neutral.red,
      green = gruvbox.neutral.green,
      yellow = gruvbox.neutral.yellow,
      blue = gruvbox.neutral.blue,
      purple = gruvbox.neutral.purple,
      aqua = gruvbox.neutral.aqua,
      orange = gruvbox.neutral.orange,
    },
  }

  return gruvbox
end

local color = get_gruvbox()
color.dark.bg = color.dark.bg0_h

color.gruvbox = get_gruvbox

return color
