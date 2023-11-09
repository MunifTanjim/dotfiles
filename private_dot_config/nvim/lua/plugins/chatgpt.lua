local plugin = {
  "jackMort/ChatGPT.nvim",
  cmd = { "ChatGPT" },
}

function plugin.config()
  require("chatgpt").setup({})
end

return plugin
