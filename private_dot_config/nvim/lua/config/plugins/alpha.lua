local alpha = require("alpha")
local fortune = require("alpha.fortune")

local header = {
  type = "text",
  val = {
    [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
    [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
    [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
    [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
    [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
    [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
  },
  opts = {
    position = "center",
    hl = "Identifier",
  },
}

local footer = {
  type = "text",
  val = fortune(),
  opts = {
    position = "center",
    hl = "Constant",
  },
}

local leader = "<Leader>"

--- @param shortcut string
--- @param text string
--- @param action? string
--- @param keymap_opts? table
local function button(shortcut, text, action, keymap_opts)
  local key = shortcut:gsub("%s", ""):gsub(leader, "<leader>")

  local opts = {
    position = "center",
    shortcut = shortcut,
    cursor = 5,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Type",
  }

  if action then
    keymap_opts = keymap_opts or { noremap = true, silent = true, nowait = true }
    opts.keymap = { "n", key, action, keymap_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(key .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "t", false)
  end

  return {
    type = "button",
    val = text,
    on_press = on_press,
    opts = opts,
  }
end

local buttons = {
  type = "group",
  val = {
    button("e", "  Empty File", "<cmd>ene <CR>"),
    button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
    button("g", "  Live Grep", "<cmd>Telescope live_grep<CR>"),
    button("o", "  Recently Opened Files", "<cmd>Telescope oldfiles only_cwd=true<CR>"),
    button("r", "  Frecency/MRU Files", "<cmd>Telescope frecency workspace=CWD<CR>"),
    button("q", "✖  Quit", "<cmd>q<CR>"),
  },
  opts = {
    spacing = 1,
  },
}

local section = {
  header = header,
  buttons = buttons,
  footer = footer,
}

local config = {
  layout = {
    { type = "padding", val = 2 },
    section.header,
    { type = "padding", val = 2 },
    section.buttons,
    section.footer,
  },
  opts = {
    margin = 5,
  },
}

alpha.setup(config)
