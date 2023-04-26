local local_git_dir = vim.fn.expand("$HOME/Dev")
local git_host_by_provider = {
  github = "github.com",
}

local function make_local(spec)
  if type(spec) == "string" then
    spec = { spec }
  end

  local git_provider = spec.git_provider
  if not git_provider or not git_host_by_provider[git_provider] then
    git_provider = "github"
  end

  local plugin_dir = string.format("%s/%s/%s", local_git_dir, git_provider, spec[1])
  local plugin_url = string.format("https://%s/%s", git_host_by_provider[git_provider], spec[1])
  if not vim.loop.fs_stat(plugin_dir) then
    vim.fn.system({ "git", "clone", plugin_url, plugin_dir })
  end

  spec.dev = true
  spec.dir = plugin_dir
  spec.url = plugin_url

  return spec
end

local plugins = {
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.ui.alpha")
    end,
  },

  make_local({
    "MunifTanjim/nui.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.ui.nui")
    end,
  }),

  make_local({
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
      local u = require("config.utils")
      u.set_keymap("n", "<Leader>e", ":Neotree toggle<CR>", "toggle file tree", { silent = true })
    end,
    config = function()
      require("plugins.ui.neo-tree")
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    init = function()
      local u = require("config.utils")
      u.set_keymap("n", "<Leader>S", ":Spectre<CR>", "toggle spectre")
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
  table.insert(plugins, { "stsewd/fzf-checkout.vim" })
end

return plugins
