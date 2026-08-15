local langs = {
  "comment",
  "css",
  "go",
  "graphql",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local parser_config = require("nvim-treesitter.parsers")

-- disable treesitter for zsh
parser_config.zsh = {
  install_info = {},
  used_by = {},
  maintainers = {},
}

require("nvim-treesitter").setup({})

require("nvim-treesitter").install(langs)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter.setup", {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match

    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end

    if language ~= "yaml" then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end

    vim.treesitter.start(buf, language)

    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
