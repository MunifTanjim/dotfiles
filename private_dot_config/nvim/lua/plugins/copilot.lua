local plugin = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
}

function plugin.config()
  local u = require("config.utils")

  require("copilot").setup({
    panel = {
      auto_refresh = false,
      keymap = {
        accept = "<CR>",
        jump_prev = "[[",
        jump_next = "]]",
        refresh = "gr",
        open = "<M-CR>",
      },
    },
    suggestion = {
      auto_trigger = false,
      keymap = {
        accept = false,
        accept_word = "<M-Right>",
        accept_line = "<M-Down>",
        prev = "<M-[>",
        next = "<M-]>",
        dismiss = false,
      },
    },
    copilot_node_command = vim.fn.expand("~/.local/share/fnm/aliases/lts-krypton/bin/node"),
  })

  local suggestion = require("copilot.suggestion")

  u.set_keymap("i", "<M-l>", function()
    if suggestion.is_visible() then
      suggestion.accept()
    else
      suggestion.next()
    end
  end, "[copilot] accept or next suggestion")
end

return plugin
