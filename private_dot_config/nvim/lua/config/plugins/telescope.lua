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
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    frecency = {
      default_workspace = "LSP",
    },
  },
  pickers = {
    find_files = {
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

vim.keymap.set("n", "<Leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<Leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<Leader>fh", require("telescope.builtin").help_tags)

vim.keymap.set("n", "<Leader>fr", function()
  require("telescope.builtin").lsp_references({ layout_strategy = "vertical" })
end)

vim.keymap.set("n", "<Leader>f;", require("telescope.builtin").resume)
