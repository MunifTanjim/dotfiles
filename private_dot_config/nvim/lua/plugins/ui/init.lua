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
    main = "ibl",
    event = "BufReadPre",
    config = function()
      require("plugins.ui.indent-blankline")
    end,
  },

  u.dev_plugin({
    "MunifTanjim/quickfix.nvim",
    event = "VeryLazy",
    opts = {},
  }),

  {
    "kevinhwang91/nvim-bqf",
    -- enabled = false,
    event = "VeryLazy",
    config = function()
      require("plugins.ui.quickfix")
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    enabled = false,
    lazy = true,
    init = function()
      require("config.utils").set_keymaps("n", {
        {
          "*",
          [[*<Cmd>lua require('hlslens').start()<CR>]],
          "[search] nearest word forward",
        },
        {
          "g*",
          [[g*<Cmd>lua require('hlslens').start()<CR>]],
          "[search] nearest partial-word forward",
        },
        {
          "#",
          [[#<Cmd>lua require('hlslens').start()<CR>]],
          "[search] nearest word backward",
        },
        {
          "g#",
          [[g#<Cmd>lua require('hlslens').start()<CR>]],
          "[search] nearest partial-word backward",
        },
        {
          "n",
          [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
          "[search] jump next",
        },
        {
          "N",
          [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
          "[search] jump prev",
        },
        {
          "<C-l>",
          [[<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><Bar>v:lua.require'hlslens'.stop()<CR>]],
          "[search] clear",
        },
      })
    end,
    opts = {
      nearest_only = true,
    },
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
