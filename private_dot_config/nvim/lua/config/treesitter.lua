local treesitter_configs = require("nvim-treesitter.configs")

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- disable treesitter for zsh
parser_config.zsh = {
  install_info = {},
  used_by = {},
  maintainers = {},
}

treesitter_configs.setup({
  ensure_installed = {
    "comment",
    "css",
    "go",
    "graphql",
    "html",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "jsonc",
    "toml",
    "yaml",
    "lua",
    "python",
    "query",
    "regex",
    "ruby",
    "rust",
    "vim",
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  playground = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
    },
  },
})

vim.cmd([[
  nmap <Leader>ghg :TSHighlightCapturesUnderCursor<CR>
  nmap <Leader>gtr :TSPlaygroundToggle<CR>
]])

vim.cmd([[
  autocmd Syntax css,go,html,javascript,javascriptreact,json,python,ruby,rust,toml,typescript,typescriptreact,yaml
   \ set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
]])
