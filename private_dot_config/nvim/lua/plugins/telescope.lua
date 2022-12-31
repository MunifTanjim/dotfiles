local plugin = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
      },
    },
  },
}

function plugin.init()
  local u = require("config.utils")

  u.set_keymaps("n", {
    {
      "<Leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      "[telescope] buffers",
    },
    {
      "<Leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      "[telescope] files",
    },
    {
      "<Leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      "[telescope] content",
    },
    {
      "<Leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      "[telescope] help tags",
    },
    {
      "<Leader>fr",
      function()
        require("telescope.builtin").lsp_references({ layout_strategy = "vertical" })
      end,
      "[telescope] lsp references",
    },
    {
      "<Leader>f;",
      function()
        require("telescope.builtin").resume()
      end,
      "[telescope] resume picker",
    },
  })
end

function plugin.config()
  local telescope = require("telescope")

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-s>"] = "select_horizontal",
        },
        n = {
          ["<C-s>"] = "select_horizontal",
        },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      frecency = {
        default_workspace = "LSP",
        show_unindexed = false,
      },
    },
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--color", "never" },
        hidden = true,
      },
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end,
        glob_pattern = { "!.git" },
      },
    },
  })

  telescope.load_extension("fzf")
  telescope.load_extension("frecency")
end

return plugin
