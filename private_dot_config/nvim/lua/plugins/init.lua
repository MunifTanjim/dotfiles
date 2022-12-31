local plugins = {
  -- appearance
  { "gruvbox-community/gruvbox" },

  -- functionality
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
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
    event = "VeryLazy",
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
  { "kristijanhusak/vim-carbon-now-sh" },
  {
    "RyanMillerC/better-vim-tmux-resizer",
    event = "VeryLazy",
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },

  -- language support
  { "bronzehedwick/msmtp-syntax.vim" },
  { "chunkhang/vim-mbsync" },
  { "fladson/vim-kitty" },
  {
    "Fymyte/rasi.vim",
    ft = { "rasi" },
  },
  { "lifepillar/pgsql.vim" },
  { "mustache/vim-mustache-handlebars" },
  { "neoclide/jsonc.vim" },
  { "neomutt/neomutt.vim" },
  { "tmux-plugins/vim-tmux" },
  { "tpope/vim-git" },
  { "vitalk/vim-shebang" },
}

return plugins
