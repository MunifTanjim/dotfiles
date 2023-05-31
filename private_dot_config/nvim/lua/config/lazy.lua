local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazy_path })
  vim.fn.system({ "git", "-C", lazy_path, "checkout", "tags/stable" })
end

vim.opt.runtimepath:prepend(lazy_path)

require("lazy").setup("plugins", {
  checker = {
    enabled = true,
    concurrency = 8,
    frequency = 24 * 60 * 60, -- 24h
    notify = false,
  },
  concurrency = 8,
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
  },
})
