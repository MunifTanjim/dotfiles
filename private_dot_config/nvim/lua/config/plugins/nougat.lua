local color = require("config.color")
local core = require("nui.bar.core")
local Bar = require("nougat.bar")
local bar_util = require("nougat.bar.util")
local Item = require("nougat.item")
local sep = require("nougat.separator")
local nut = {
  buf = {
    diagnostic_count = require("nougat.nut.buf.diagnostic_count").create,
    fileencoding = require("nougat.nut.buf.fileencoding").create,
    fileformat = require("nougat.nut.buf.fileformat").create,
    filename = require("nougat.nut.buf.filename").create,
    filetype = require("nougat.nut.buf.filetype").create,
    wordcount = require("nougat.nut.buf.wordcount").create,
  },
  git = {
    branch = require("nougat.nut.git.branch").create,
  },
  mode = require("nougat.nut.mode").create,
  ruler = require("nougat.nut.ruler").create,
  spacer = require("nougat.nut.spacer").create,
}

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

local mode = nut.mode({
  prefix = " ",
  suffix = " ",
  config = {
    highlight = {
      normal = {
        fg = color.dark.bg,
      },
      visual = {
        bg = color.dark.orange,
        fg = color.dark.bg,
      },
      insert = {
        bg = color.dark.blue,
        fg = color.dark.bg,
      },
      replace = {
        bg = color.dark.purple,
        fg = color.dark.bg,
      },
      commandline = {
        bg = color.dark.green,
        fg = color.dark.bg,
      },
      terminal = {
        bg = color.dark.accent.green,
        fg = color.dark.bg,
      },
      inactive = {},
    },
  },
})
stl:add_item(mode)
stl:add_item(core.truncation_point())
stl:add_item(nut.git.branch({
  hl = { bg = color.dark.bg3, fg = color.dark.fg1 },
  prefix = { "  ", " " },
  suffix = " ",
}))
stl:add_item(nut.buf.filename({
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
}))
stl:add_item(core.truncation_point())
stl:add_item(nut.spacer())
stl:add_item(nut.buf.filetype({
  prefix = " ",
  suffix = " ",
}))
stl:add_item(nut.buf.diagnostic_count({
  hidden = function(item, ctx)
    return item.cache[ctx.bufnr][item:config(ctx).severity] == 0
  end,
  hl = { bg = color.dark.bg3 },
  prefix = " ",
  suffix = " ",
  config = {
    error = { prefix = " ", fg = color.dark.red },
    warn = { prefix = " ", fg = color.dark.yellow },
    info = { prefix = " ", fg = color.dark.blue },
    hint = { prefix = " ", fg = color.dark.green },
  },
}))
stl:add_item(nut.buf.fileencoding({
  hidden = function(_, ctx)
    return vim.bo[ctx.bufnr].fileencoding == "utf-8"
  end,
  prefix = " ",
  suffix = " ",
}))
stl:add_item(nut.buf.fileformat({
  hidden = function(_, ctx)
    return vim.bo[ctx.bufnr].fileformat == "unix"
  end,
  hl = { bg = color.dark.bg3, fg = "fg" },
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
local wordcount_enabled = {
  markdown = true,
}
stl:add_item(nut.buf.wordcount({
  hidden = function(_, ctx)
    return not wordcount_enabled[vim.bo[ctx.bufnr].filetype]
  end,
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

local stl_inactive = Bar("statusline")
stl_inactive:add_item(mode)
stl_inactive:add_item(core.truncation_point())
stl_inactive:add_item(nut.buf.filename({
  prefix = " ",
  suffix = " ",
}))

local hidden_mode = nut.mode({ hidden = true })

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
  }

  function item:content(ctx)
    return self.name_by_filetype[vim.bo[ctx.bufnr].filetype] or ""
  end

  return item
end)()

local stl_fugitive = Bar("statusline")
stl_fugitive:add_item(hidden_mode)
stl_fugitive:add_item(filetype_mode)
stl_fugitive:add_item(nut.git.branch({
  hl = { bg = color.dark.bg3, fg = color.dark.fg1 },
  prefix = "  ",
  suffix = " ",
  config = { provider = "fugitive" },
}))

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

local stl_neotree = Bar("statusline")
stl_neotree:add_item(hidden_mode)
stl_neotree:add_item(filetype_mode)

bar_util.set_statusline(function(ctx)
  return ctx.is_focused and stl or stl_inactive
end)

for ft, stl_ft in pairs({
  fugitive = stl_fugitive,
  help = stl_help,
  ["neo-tree"] = stl_neotree,
}) do
  bar_util.set_statusline(stl_ft, { filetype = ft })
end
