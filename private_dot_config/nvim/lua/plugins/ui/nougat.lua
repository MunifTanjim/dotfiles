local nougat = require("nougat")
local core = require("nougat.core")
local Bar = require("nougat.bar")
local Item = require("nougat.item")
local sep = require("nougat.separator")
local nut = {
  buf = {
    diagnostic_count = require("nougat.nut.buf.diagnostic_count"),
    fileencoding = require("nougat.nut.buf.fileencoding").create,
    fileformat = require("nougat.nut.buf.fileformat").create,
    filename = require("nougat.nut.buf.filename").create,
    filestatus = require("nougat.nut.buf.filestatus").create,
    filetype = require("nougat.nut.buf.filetype").create,
    filetype_icon = require("nougat.nut.buf.filetype_icon").create,
    wordcount = require("nougat.nut.buf.wordcount"),
  },
  git = {
    branch = require("nougat.nut.git.branch").create,
    status = require("nougat.nut.git.status"),
  },
  tab = {
    tablist = {
      tabs = require("nougat.nut.tab.tablist").create,
      close = require("nougat.nut.tab.tablist.close").create,
      icon = require("nougat.nut.tab.tablist.icon").create,
      label = require("nougat.nut.tab.tablist.label").create,
      modified = require("nougat.nut.tab.tablist.modified").create,
    },
  },
  mode = require("nougat.nut.mode").create,
  ruler = require("nougat.nut.ruler").create,
  spacer = require("nougat.nut.spacer").create,
}

local color = require("nougat.color").get() --[[@as nougat.color.gruvbox]]

vim.o.rulerformat = table.concat({
  core.code("p"),
  "%% L:",
  core.code("l"),
  "/",
  core.code("L"),
  " C:",
  core.code("v"),
})

local breakpoint = { l = 1, m = 2, s = 3 }
local breakpoints = { [breakpoint.l] = math.huge, [breakpoint.m] = 128, [breakpoint.s] = 80 }

local stl = Bar("statusline", { breakpoints = breakpoints })

local mode_highlight = {
  normal = {
    fg = color.bg,
  },
  visual = {
    bg = color.orange,
    fg = color.bg,
  },
  insert = {
    bg = color.blue,
    fg = color.bg,
  },
  replace = {
    bg = color.magenta,
    fg = color.bg,
  },
  commandline = {
    bg = color.green,
    fg = color.bg,
  },
  terminal = {
    bg = color.accent.cyan,
    fg = color.bg,
  },
  inactive = {},
}
local mode = nut.mode({
  prefix = " ",
  suffix = " ",
  config = {
    highlight = mode_highlight,
    [breakpoint.s] = {
      text = {
        ["n"] = "N",
        ["no"] = "NO",
        ["nov"] = "NOC",
        ["noV"] = "NOL",
        ["no"] = "NOB",
        ["niI"] = "I(N)",
        ["niR"] = "R(N)",
        ["niV"] = "VR(N)",
        ["nt"] = "TN",
        ["ntT"] = "T(N)",

        ["v"] = "V",
        ["vs"] = "S(V)",
        ["V"] = "VL",
        ["Vs"] = "S(VL)",
        [""] = "VB",
        ["s"] = "S(VB)",

        ["s"] = "S",
        ["S"] = "SL",
        [""] = "SB",

        ["i"] = "I",
        ["ic"] = "ICG",
        ["ix"] = "IC",

        ["R"] = "R",
        ["Rc"] = "RCG",
        ["Rx"] = "RC",
        ["Rv"] = "VR",
        ["Rvc"] = "VRCG",
        ["Rvx"] = "VRC",

        ["c"] = "C",
        ["cv"] = "VEX",
        ["ce"] = "EX",
        ["r"] = "P",
        ["rm"] = "MP",
        ["r?"] = "C?",
        ["!"] = "#",

        ["t"] = "T",

        ["-"] = "-",
      },
    },
  },
})
stl:add_item(mode)
stl:add_item(core.truncation_point())
stl:add_item(nut.git.branch({
  hl = { bg = color.bg3, fg = color.fg1 },
  prefix = { "  ", " " },
  suffix = " ",
  config = { provider = "fugitive" },
}))
stl:add_item(nut.git.status.create({
  hl = { bg = color.bg3 },
  suffix = " ",
  content = {
    nut.git.status.count("added", {
      hl = { fg = color.green },
      prefix = "+",
    }),
    nut.git.status.count("changed", {
      hl = { fg = color.yellow },
      prefix = "~",
    }),
    nut.git.status.count("removed", {
      hl = { fg = color.red },
      prefix = "-",
    }),
  },
}))
local filestatus = nut.buf.filestatus({
  prefix = " ",
  config = {
    modified = "●",
    nomodifiable = "",
    readonly = "",
    sep = " ",
  },
})
stl:add_item(filestatus)
local filename = nut.buf.filename({
  prefix = " ",
  suffix = " ",
  config = {
    modifier = ":.",
    [breakpoint.m] = {
      format = function(name)
        return table.concat({ vim.fn.pathshorten(vim.fn.fnamemodify(name, ":h")), "/", vim.fn.fnamemodify(name, ":t") })
      end,
    },
    [breakpoint.s] = { modifier = ":t", format = false },
  },
})
stl:add_item(filename)
stl:add_item(core.truncation_point())
stl:add_item(nut.spacer())
stl:add_item({
  prefix = " ",
  content = {
    nut.buf.filetype_icon({ suffix = " " }),
    nut.buf.filetype({}),
  },
  suffix = " ",
})
stl:add_item(nut.buf.diagnostic_count.create({
  hidden = nut.buf.diagnostic_count.hidden.if_zero(),
  hl = { bg = color.bg3 },
  prefix = " ",
  suffix = " ",
  config = {
    error = { prefix = " ", fg = color.red },
    warn = { prefix = " ", fg = color.yellow },
    info = { prefix = " ", fg = color.blue },
    hint = { prefix = "󰌶 ", fg = color.green },
  },
}))
stl:add_item(nut.buf.fileencoding({
  hidden = function(_, ctx)
    return vim.api.nvim_get_option_value("fileencoding", { buf = ctx.bufnr }) == "utf-8"
  end,
  prefix = " ",
  suffix = " ",
}))
stl:add_item(nut.buf.fileformat({
  hidden = function(_, ctx)
    return vim.api.nvim_get_option_value("fileformat", { buf = ctx.bufnr }) == "unix"
  end,
  hl = { bg = color.bg3, fg = "fg" },
  prefix = " ",
  suffix = " ",
  config = {
    text = {
      dos = "",
      unix = "",
      mac = "",
    },
  },
}))
stl:add_item(nut.buf.wordcount.create({
  hidden = nut.buf.wordcount.hidden.if_not_filetype({
    markdown = true,
  }),
  hl = mode,
  sep_left = sep.space(),
  config = {
    format = function(count)
      return string.format("%d Word%s", count, count > 1 and "s" or "")
    end,
  },
}))
stl:add_item(nut.ruler({
  hl = mode,
  sep_left = sep.space(),
  suffix = " ",
}))

local stl_inactive = Bar("statusline", { breakpoints = breakpoints })
stl_inactive:add_item(mode)
stl_inactive:add_item(core.truncation_point())
stl_inactive:add_item(filestatus)
stl_inactive:add_item(filename)

local hidden_mode = nut.mode({
  hidden = true,
  config = {
    highlight = mode_highlight,
  },
})

local filetype_mode = (function()
  local item = Item({
    hl = hidden_mode,
    prefix = " ",
    suffix = " ",
  })

  item.name_by_filetype = {
    ["neo-tree"] = "NEO-TREE",
    fugitive = "FUGITIVE",
    help = "HELP",
    spectre_panel = "SPECTRE",
  }

  function item:content(ctx)
    return self.name_by_filetype[vim.api.nvim_get_option_value("filetype", { buf = ctx.bufnr })] or ""
  end

  return item
end)()

local stl_help = Bar("statusline")
stl_help:add_item(hidden_mode)
stl_help:add_item(filetype_mode)
stl_help:add_item(Item({
  type = "code",
  content = "t",
  prefix = " ",
  suffix = " ",
}))
stl_help:add_item(nut.spacer())
stl_help:add_item(nut.ruler({
  hl = hidden_mode,
  prefix = " ",
  suffix = " ",
}))

local stl_ft_generic = Bar("statusline")
stl_ft_generic:add_item(hidden_mode)
stl_ft_generic:add_item(filetype_mode)
stl_ft_generic:add_item(nut.spacer())
stl_ft_generic:add_item(nut.ruler({
  hl = hidden_mode,
  prefix = " ",
  suffix = " ",
}))

local stl_idx = 1
local stls = { stl }

local stl_switcher = Item({
  hidden = true,
  hl = { bg = color.blue, fg = color.bg0 },
  content = "",
  prefix = " ",
  suffix = " ",
  on_click = function()
    stl_idx = stl_idx == #stls and 1 or stl_idx + 1
  end,
})

vim.api.nvim_create_user_command("ToggleStatuslineSwitcher", function()
  stl_switcher.hidden = not stl_switcher.hidden
end, {
  desc = "[gui] toggle statusline switcher",
})

for _, bar in ipairs(stls) do
  bar:add_item(stl_switcher)
end

nougat.set_statusline(function(ctx)
  return ctx.is_focused and stls[stl_idx] or stl_inactive
end)

for ft, stl_ft in pairs({
  fugitive = stl_ft_generic,
  help = stl_help,
  ["neo-tree"] = stl_ft_generic,
  spectre_panel = stl_ft_generic,
}) do
  nougat.set_statusline(stl_ft, { filetype = ft })
end

local tal = Bar("tabline")

tal:add_item(nut.tab.tablist.tabs({
  active_tab = {
    hl = { bg = color.bg0, fg = color.fg0 },
    sep_left = {
      hl = { bg = color.bg0, fg = color.blue },
      content = "▎",
    },
    suffix = " ",
    content = {
      nut.tab.tablist.icon({ suffix = " " }),
      nut.tab.tablist.label({}),
      nut.tab.tablist.modified({ prefix = " ", config = { text = "●" } }),
      nut.tab.tablist.close({ prefix = " ", config = { text = "󰅖" } }),
    },
  },
  inactive_tab = {
    hl = { bg = color.bg2, fg = color.fg2 },
    sep_left = {
      hl = { bg = color.bg2, fg = color.fg3 },
      content = "▎",
    },
    suffix = " ",
    content = {
      nut.tab.tablist.icon({ suffix = " " }),
      nut.tab.tablist.label({}),
      nut.tab.tablist.modified({ prefix = " ", config = { text = "●" } }),
      nut.tab.tablist.close({ prefix = " ", config = { text = "󰅖" } }),
    },
  },
}))

nougat.set_tabline(tal)
