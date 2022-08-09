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

vim.cmd([[
  nnoremap <Leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <Leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <Leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <Leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

  nnoremap <Leader>fr <cmd>lua require('telescope.builtin').lsp_references({ layout_strategy = 'vertical' })<cr>

  nnoremap <Leader>f; <cmd>lua require('telescope.builtin').resume()<cr>
]])
