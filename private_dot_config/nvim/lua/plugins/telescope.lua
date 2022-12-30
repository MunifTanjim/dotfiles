local plugin = {
  "nvim-telescope/telescope.nvim",
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

function plugin.config()
  local u = require("config.utils")
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

  u.set_keymaps("n", {
    { "<Leader>fb", require("telescope.builtin").buffers, "[telescope] buffers" },
    { "<Leader>ff", require("telescope.builtin").find_files, "[telescope] files" },
    { "<Leader>fg", require("telescope.builtin").live_grep, "[telescope] content" },
    { "<Leader>fh", require("telescope.builtin").help_tags, "[telescope] help tags" },
    {
      "<Leader>fr",
      function()
        require("telescope.builtin").lsp_references({ layout_strategy = "vertical" })
      end,
      "[telescope] lsp references",
    },
    { "<Leader>f;", require("telescope.builtin").resume, "[telescope] resume picker" },
  })
end

return plugin
