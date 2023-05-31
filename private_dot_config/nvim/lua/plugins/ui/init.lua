local u = require("config.utils")

local plugins = {
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.ui.alpha")
    end,
  },

  u.dev_plugin({
    "MunifTanjim/nui.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.ui.nui")
    end,
  }),

  u.dev_plugin({
    "MunifTanjim/nougat.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.ui.nougat")
    end,
  }),

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      "s1n7ax/nvim-window-picker",
    },
    cmd = "Neotree",
    init = function()
      u.set_keymap("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", "toggle file tree")
    end,
    config = function()
      require("plugins.ui.neo-tree")
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    init = function()
      u.set_keymap("n", "<Leader>S", "<Cmd>Spectre<CR>", "toggle spectre")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("plugins.ui.indent-blankline")
    end,
  },
}

local fzf_root = vim.fn.fnamemodify(vim.fn.stdpath("data"), ":h") .. "/fzf"
if vim.fn.isdirectory(fzf_root) == 1 then
  table.insert(plugins, {
    "junegunn/fzf",
    dev = true,
    dir = fzf_root,
  })
  table.insert(plugins, { "junegunn/fzf.vim" })
end

return plugins
