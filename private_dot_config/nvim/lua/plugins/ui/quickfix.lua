vim.opt.quickfixtextfunc = "v:lua.require'plugins.ui.quickfix'.format"

local type_sign = {
  E = "E",
  W = "W",
  I = "I",
  H = "H",
  N = "N",
}

local type_hl_group = {
  E = "qfError",
  W = "qfWarn",
  I = "qfInfo",
  H = "qfHint",
  N = "qfNote",
}

---@param winid integer
---@return ''|'autocmd'|'command'|'loclist'|'popup'|'preview'|'quickfix'|'unknown' win_type
local function get_win_type(winid)
  return vim.fn.win_gettype(vim.fn.win_id2win(winid or vim.api.nvim_get_current_win()))
end

---@param bufnr integer
---@param max_width integer
---@return string
local function format_bufname(bufnr, max_width)
  local fname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p:~:.")
  local attempt = 3
  while max_width < vim.fn.strwidth(fname) do
    if attempt == -1 then
      fname = ""
      break
    elseif attempt == 0 then
      fname = vim.fn.fnamemodify(fname, ":t")
    else
      fname = vim.fn.pathshorten(fname, attempt * 2 - 1)
    end
    attempt = attempt - 1
  end
  return fname
end

require("bqf.preview.floatwin").generateTitle = function(self, bufnr, idx, size)
  local position = (" [%d/%d] "):format(idx, size)
  local buffer = ("buf %d: "):format(bufnr)
  local flags = vim.bo[bufnr].modified and " [+] " or " "

  local max_width = self.width - 4 - vim.fn.strwidth(buffer) - vim.fn.strwidth(position) - vim.fn.strwidth(flags)
  local bufname = format_bufname(bufnr, max_width)

  return ("%s%s%s%s"):format(position, buffer, bufname, flags)
end

local bqf = require("bqf")

bqf.setup({
  auto_resize_height = true,
  fn_map = {
    split = "<C-s>",
  },
  preview = {
    auto_preview = false,
    border = "single",
    winblend = 0,
  },
})

local function get_quickfix_item_hover()
  local winid = vim.api.nvim_get_current_win()
  local win_type = get_win_type(winid)

  local Popup = require("nui.popup")
  local Line = require("nui.line")
  local Text = require("nui.text")

  local popup = Popup({
    focusable = false,
    border = {
      style = "single",
      text = {},
    },
    anchor = "NW",
    position = { row = 1, col = 0 },
    relative = { type = "buf", position = { row = 0, col = 0 } },
    size = { height = 1, width = "100%" },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  })

  return function()
    local linenr = vim.api.nvim_win_get_cursor(winid)[1]

    local item
    if win_type == "loclist" then
      item = vim.fn.getloclist(winid, { id = 0, idx = linenr, items = 0 }).items[1]
    elseif win_type == "quickfix" then
      item = vim.fn.getqflist({ id = 0, idx = linenr, items = 0 }).items[1]
    end

    if not item then
      return
    end

    local wininfo = vim.fn.getwininfo(winid)[1]

    local lines = vim.tbl_map(function(line)
      return Line({ Text(line) })
    end, vim.split(item.text, "\n", { plain = true }))

    local size = {
      height = #lines,
      width = wininfo.width - wininfo.textoff - 1,
    }

    local item_type = (type_sign[item.type] or item.type):sub(1, 1):upper()
    local type_chunk = Text(#item.type > 0 and item_type .. " " or "", type_hl_group[item.type])
    local position_chunk = Text(string.format(":%s:%s", item.lnum, item.col), "qfPosition")
    local border_text = Line({
      type_chunk,
      Text(format_bufname(item.bufnr, size.width - type_chunk:width() - position_chunk:width()), "qfPath"),
      position_chunk,
    })

    if wininfo.botline - linenr + 1 >= size.height + 2 then
      popup:update_layout({
        anchor = "NW",
        position = { row = 1, col = 0 },
        relative = { type = "buf", position = { row = linenr - 1, col = 0 } },
        size = size,
      })
      popup.border:set_text("bottom", nil, nil)
      popup.border:set_text("top", border_text, "left")
    else
      popup:update_layout({
        anchor = "SW",
        position = { row = 2, col = 0 },
        relative = { type = "buf", position = { row = linenr - 1, col = 0 } },
        size = size,
      })
      popup.border:set_text("top", nil, nil)
      popup.border:set_text("bottom", border_text, "left")
    end

    require("nui.utils")._.render_lines(lines, popup.bufnr, popup.ns_id, 1, -1)

    vim.api.nvim_create_autocmd({ "CursorMoved", "WinLeave" }, {
      buffer = wininfo.bufnr,
      callback = function()
        popup:hide()
      end,
      once = true,
    })

    if popup._.mounted then
      popup:show()
    else
      popup:mount()
    end
  end
end

-- hook into bqf.enable
local original_bqf_enable = bqf.enable
function bqf.enable()
  -- issue: https://github.com/neovim/neovim/issues/23956
  vim.o.scrolloff = 3

  local win_type = get_win_type(0)

  require("config.utils").set_keymaps("n", {
    {
      "gq",
      function()
        if win_type == "loclist" then
          vim.cmd("lclose")
        elseif win_type == "quickfix" then
          vim.cmd("cclose")
        end
      end,
      "[quickfix] close",
    },
    {
      "gr",
      function()
        if win_type == "loclist" then
          vim.cmd("lopen")
        elseif win_type == "quickfix" then
          vim.cmd("copen")
        end
      end,
      "[quickfix] refresh",
    },
    {
      "K",
      get_quickfix_item_hover(),
      "[quickfix] hover",
    },
  }, { buffer = 0 })

  return original_bqf_enable()
end

local qf = {}

vim.schedule(function()
  for name, link in pairs({
    [type_hl_group.E] = "DiagnosticError",
    [type_hl_group.W] = "DiagnosticWarn",
    [type_hl_group.I] = "DiagnosticInfo",
    [type_hl_group.H] = "DiagnosticHint",
    [type_hl_group.N] = "DiagnosticHint",
    qfPath = "Directory",
    qfPosition = "Number",
  }) do
    vim.api.nvim_set_hl(0, name, { link = link })
  end
end)

local syntax_template = [[
  setlocal conceallevel=2
  setlocal concealcursor=nvic

  syn match %s '^%s ' nextgroup=qfPath
  syn match %s '^%s ' nextgroup=qfPath
  syn match %s '^%s ' nextgroup=qfPath
  syn match %s '^%s ' nextgroup=qfPath
  syn match %s '^%s ' nextgroup=qfPath

  syn match qfWithoutType '^< ' nextgroup=qfPath conceal

  syn match qfPath '[^:]\+' nextgroup=qfPosition contained
  syn match qfPosition ':[0-9]\+\(:[0-9]\+\)\?' contained
]]

function qf.syntax()
  vim.cmd(
    syntax_template:format(
      type_hl_group.E,
      type_sign.E,
      type_hl_group.W,
      type_sign.W,
      type_hl_group.I,
      type_sign.I,
      type_hl_group.H,
      type_sign.H,
      type_hl_group.N,
      type_sign.N
    )
  )
end

---@alias vim_quickfixtextfunc_param { quickfix: 1|0, winid: integer, id: integer, start_idx: integer, end_idx: integer }

---@class vim_quickfix_list_item
---@field bufnr integer
---@field module string
---@field lnum integer
---@field end_lnum integer
---@field col integer
---@field end_col integer
---@field vcol 0|1
---@field nr integer
---@field pattern string
---@field text string
---@field type string
---@field valid 0|1

---@param info vim_quickfixtextfunc_param
---@return string[]
function qf.format(info)
  ---@type vim_quickfix_list_item[]
  local items = info.quickfix == 1 and vim.fn.getqflist({ id = info.id, items = 0 }).items
    or vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items

  local max_location_length = math.floor(vim.api.nvim_win_get_width(info.winid) / 2) - 10

  local has_type = false
  local location_length = 0

  for idx = info.start_idx, info.end_idx do
    local item = items[idx]

    local location = "?"

    if item.bufnr > 0 then
      location = vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ":p:~:.")
      if #location > max_location_length then
        location = vim.fn.pathshorten(location, 2)
        if #location > max_location_length then
          location = "…" .. location:sub(-max_location_length)
        end
      end
    end

    if item.lnum then
      location = string.format("%s:%s:%s", location, item.lnum, item.col)
    end

    local location_len = #location
    if location_length < location_len then
      location_length = location_len
    end

    item.location = location

    if #item.type > 0 then
      has_type = true
    end
  end

  local line_fmt = "%-2s%s%s%s"

  for idx = info.start_idx, info.end_idx do
    ---@type vim_quickfix_list_item|{ location: string }
    local item = items[idx]

    local item_type = has_type and (type_sign[item.type] or item.type):sub(1, 1):upper() or "<"
    local location = item.location
    local location_padding = string.rep(" ", location_length - #item.location + 1)
    local text = vim.fn.trim(vim.split(item.text, "\n")[1])

    ---@type string
    items[idx] = line_fmt:format(item_type, location, location_padding, text)
  end

  return items --[=[@as string[]]=]
end

return qf
