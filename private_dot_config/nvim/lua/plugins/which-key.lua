local plugin = {
  "folke/which-key.nvim",
}

---@module 'which-key'
local wk

---@param mode string|string[]
---@param lhs string
---@param rhs string|fun():nil
---@param desc_or_opts string|table
---@param opts? table
local function set_keymap(mode, lhs, rhs, desc_or_opts, opts)
  if opts then
    opts.desc = desc_or_opts
  else
    opts = type(desc_or_opts) == "table" and desc_or_opts or { desc = desc_or_opts }
  end

  opts.mode = type(mode) == "table" and mode or { mode }
  opts[1] = lhs
  opts[2] = rhs

  wk.add(opts)
end

---@param default_mode string|string[]
---@param maps ({[1]: string, [2]: string|(fun():nil), [3]?: string|table, [4]?: table}|table)[]
---@param fallback_opts? table
local function set_keymaps(default_mode, maps, fallback_opts)
  fallback_opts = fallback_opts or {}

  local specs = { len = 0 }

  for _, map in ipairs(maps) do
    if not map.mode then
      map.mode = default_mode
    end

    local desc, opts = map[3], map[4]
    map[3], map[4] = nil, nil

    if opts then
      opts.desc = desc
    else
      opts = type(desc) == "table" and desc or { desc = desc }
    end

    specs.len = specs.len + 1
    specs[specs.len] = vim.tbl_extend("keep", map, opts, fallback_opts)
  end

  specs.len = nil

  wk.add(specs)
end

function plugin.config()
  local u = require("config.utils")

  wk = require("which-key")

  wk.setup({
    preset = "helix",
    plugins = {
      presets = {
        -- operators = false,
      },
    },
    win = {
      border = "single",
      padding = { 0, 0 },
    },
  })

  wk.add({
    { "<Leader>d", group = "DAP" },
    { "<Leader>f", group = "Telescope" },
    { "<Leader>o", group = "Open" },
  })

  u.set_keymap = set_keymap
  u.set_keymaps = set_keymaps
end

return plugin
