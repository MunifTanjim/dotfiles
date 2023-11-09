require("bqf.preview.floatwin").generateTitle = function(self, bufnr, idx, size)
  local position = (" [%d/%d] "):format(idx, size)
  local buffer = ("buf %d: "):format(bufnr)
  local flags = vim.bo[bufnr].modified and " [+] " or " "

  local max_width = self.width - 4 - vim.fn.strwidth(buffer) - vim.fn.strwidth(position) - vim.fn.strwidth(flags)
  local bufname = require("quickfix.util").format_bufname(bufnr, max_width)

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

local qf = {}

return qf
