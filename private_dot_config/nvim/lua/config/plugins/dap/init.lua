local dap = require("dap")
local dap_ui = require("dapui")
local dap_vt = require("nvim-dap-virtual-text")

dap_vt.setup({
  enabled = true,
  enable_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = false,
  all_references = false,
  filter_references_pattern = "<module",
  virt_text_pos = "eol",
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
})

dap_ui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap_ui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dap_ui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dap_ui.close()
end

local function setup_keymaps()
  local function opts(desc)
    return { desc = desc, silent = true }
  end

  vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, opts("DAP Breakpoint"))
  vim.keymap.set("n", "<Leader>dB", function()
    local condition = vim.fn.input("Breakpoint condition: ")
    local hit_condition = vim.fn.input("Breakpoint hit condition: ")
    local log_message = vim.fn.input("Breakpoint log message: ")
    dap.set_breakpoint(condition, hit_condition, log_message)
  end, opts("DAP Conditional Breakpoint"))

  vim.keymap.set("n", "<Leader>dc", dap.continue, opts("DAP Continue"))
  vim.keymap.set("n", "<Leader>dp", dap.pause, opts("DAP Pause"))
  vim.keymap.set("n", "<Leader>dt", dap.terminate, opts("DAP Terminate"))

  vim.keymap.set("n", "<Leader>di", dap.step_into, opts("DAP Step Into"))
  vim.keymap.set("n", "<Leader>do", dap.step_out, opts("DAP Step Out"))
  vim.keymap.set("n", "<Leader>dO", dap.step_over, opts("DAP Step Over"))
  vim.keymap.set("n", "<Leader>drc", dap.run_to_cursor, opts("DAP Run to Cursor"))

  vim.keymap.set("n", "<Leader>dh", dap_ui.eval, opts("DAP Eval"))
end

setup_keymaps()

require("config.plugins.dap.javascript")