local plugins = {
  -- appearance
  { "gruvbox-community/gruvbox" },

  -- functionality
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
  },
  { "bkad/CamelCaseMotion" },
  {
    "heavenshell/vim-jsdoc",
    ft = {
      "javascript",
      "javascriptreact",
    },
    build = "make install",
  },
  { "junegunn/vim-easy-align" },
  { "powerman/vim-plugin-AnsiEsc" },
  {
    "rrethy/vim-hexokinase",
    build = "make hexokinase",
    event = "BufReadPost",
  },
  { "szw/vim-maximizer" },
  { "tpope/vim-repeat" },
  { "tpope/vim-sensible" },
  { "tpope/vim-surround" },
  { "tpope/vim-unimpaired" },

  -- integration
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },
  {
    "kristijanhusak/vim-carbon-now-sh",
    cmd = "CarbonNowSh",
  },
  {
    "RyanMillerC/better-vim-tmux-resizer",
    event = "VeryLazy",
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },

  -- language support
  {
    "bronzehedwick/msmtp-syntax.vim",
    ft = "msmtp",
  },
  {
    "chunkhang/vim-mbsync",
    ft = "mbsync",
  },
  {
    "fladson/vim-kitty",
    ft = "kitty*",
  },
  {
    "Fymyte/rasi.vim",
    ft = "rasi",
  },
  {
    "lifepillar/pgsql.vim",
    ft = "sql",
  },
  {
    "mustache/vim-mustache-handlebars",
    ft = { "html.handlebars", "html.mustache" },
  },
  {
    "neoclide/jsonc.vim",
    ft = "jsonc",
  },
  {
    "neomutt/neomutt.vim",
    ft = { "mail", "neomuttlog", "neomuttrc" },
  },
  {
    "tmux-plugins/vim-tmux",
    ft = "tmux",
  },
  {
    "tpope/vim-git",
    ft = "git*",
  },
  { "vitalk/vim-shebang" },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      vim.g.undotree_DiffAutoOpen = 0
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = "*"
      vim.g.undotree_TreeReturnShape = "╲"
      vim.g.undotree_TreeVertShape = "│"
      vim.g.undotree_TreeSplitShape = "╱"
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_HelpLine = 0
    end,
  },
}

return plugins
