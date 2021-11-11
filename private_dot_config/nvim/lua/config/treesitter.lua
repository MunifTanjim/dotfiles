local treesitter_configs = require("nvim-treesitter.configs")

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- disable treesitter for zsh
parser_config.zsh = {
  install_info = {},
  used_by = {},
  maintainers = {},
}

-- parser_config.json = {
--   install_info = {
--     url = "~/Dev/github/tree-sitter/tree-sitter-json",
--     files = { "src/parser.c" },
--     generate_requires_npm = true,
--   },
-- }
-- parser_config.jsonc = {
--   install_info = {
--     url = "~/Dev/gitlab/WhyNotHugo/tree-sitter-jsonc",
--     files = { "src/parser.c" },
--     generate_requires_npm = true,
--   },
-- }

-- local read_query = function(filename)
--   return table.concat(vim.fn.readfile(vim.fn.expand(filename)), "\n")
-- end

--vim.treesitter.set_query(
--  "lua", "highlights", read_query("~/Dev/github/MunifTanjim/tree-sitter-lua/queries/lua/highlights.scm")
--)

local treesitter_lua_ok, treesitter_lua = pcall(require, "nvim-treesitter-lua")
if treesitter_lua_ok then
  treesitter_lua.setup()
end

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
})

vim.api.nvim_exec(
  [[
  nmap <Leader>ghg :TSHighlightCapturesUnderCursor<CR>
  nmap <Leader>gtr :TSPlaygroundToggle<CR>
  ]],
  false
)

vim.api.nvim_exec(
  [[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  ]],
  false
)
