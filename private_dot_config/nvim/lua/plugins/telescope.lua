local plugin = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
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
      "<Leader>fs",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      "[telescope] lsp document symbols",
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

  local layout_strategies = require("telescope.pickers.layout_strategies")

  layout_strategies._vertical = layout_strategies.vertical
  function layout_strategies.vertical(...)
    local ret = layout_strategies._vertical(...)

    if ret.preview then
      ret.preview.border = { 1, 1, 0, 1 }
      ret.preview.borderchars = vim.deepcopy(ret.preview.borderchars)
      ret.preview.height = ret.preview.height + 1
    end

    ret.results.border = { 1, 1, 0, 1 }
    ret.results.borderchars = vim.deepcopy(ret.results.borderchars)
    ret.results.borderchars[5] = "├"
    ret.results.borderchars[6] = "┤"
    ret.results.height = ret.results.height + 1

    ret.prompt.borderchars = vim.deepcopy(ret.prompt.borderchars)
    ret.prompt.borderchars[5] = "├"
    ret.prompt.borderchars[6] = "┤"

    return ret
  end

  layout_strategies._horizontal = layout_strategies.horizontal
  function layout_strategies.horizontal(...)
    local ret = layout_strategies._horizontal(...)

    if ret.preview then
      ret.preview.border = { 1, 1, 1, 0 }
      ret.preview.borderchars = vim.deepcopy(ret.preview.borderchars)
      ret.preview.col = ret.preview.col - 1
      ret.preview.width = ret.preview.width + 1
    end

    ret.results.border = { 1, 1, 0, 1 }
    ret.results.borderchars = vim.deepcopy(ret.results.borderchars)
    ret.results.borderchars[6] = "┬"
    ret.results.height = ret.results.height + 1

    ret.prompt.borderchars = vim.deepcopy(ret.prompt.borderchars)
    ret.prompt.borderchars[5] = "├"
    ret.prompt.borderchars[6] = "┤"
    ret.prompt.borderchars[7] = "┴"

    return ret
  end

  telescope.setup({
    defaults = {
      layout_config = {
        horizontal = {
          width = 0.9,
          height = 0.6,
          preview_cutoff = 120,
        },
        vertical = {
          width = 0.9,
          height = 0.9,
        },
        flex = {
          flip_columns = 120,
        },
      },
      layout_strategy = "flex",
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
end

return plugin
