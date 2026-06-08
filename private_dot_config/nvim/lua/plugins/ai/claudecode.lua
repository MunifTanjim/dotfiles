local u = require("config.utils")

local plugin = {
  "coder/claudecode.nvim",
  dependencies = {
    u.dev_plugin("MunifTanjim/claudecode-provider-tmux.nvim"),
  },
  cmd = { "ClaudeCode" },
  opts = function()
    return {
      focus_after_send = true,
      diff_opts = {
        open_in_new_tab = true,
      },
      terminal = {
        provider = require("claudecode.terminal.tmux"),
        provider_opts = {
          split_size = 80,
          split_direction = "top-right",
        },
      },
    }
  end,
  keys = {
    { "<leader>cc", nil, desc = "Claude Code", icon = "" },
    { "<leader>cco", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>ccS", "<cmd>ClaudeCodeStatus<cr>", desc = "Claude Status" },
    { "<leader>ccf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ccr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>ccC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>ccm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude Model" },
    { "<leader>ccb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add Buffer to Claude" },
    { "<leader>ccs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>ccs",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add File to Claude",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    { "<leader>cca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Diff" },
    { "<leader>ccd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Diff" },
  },
}

return plugin
