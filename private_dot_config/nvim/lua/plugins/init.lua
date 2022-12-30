local plugins = {
  -- appearance
  { "gruvbox-community/gruvbox" },

  -- functionality
  { "andymass/vim-matchup" },
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
  },
  { "szw/vim-maximizer" },
  { "tpope/vim-capslock" },
  { "tpope/vim-repeat" },
  { "tpope/vim-sensible" },
  { "tpope/vim-surround" },
  { "tpope/vim-unimpaired" },

  -- integration
  { "christoomey/vim-tmux-navigator" },
  { "kristijanhusak/vim-carbon-now-sh" },
  { "RyanMillerC/better-vim-tmux-resizer" },
  { "wakatime/vim-wakatime" },

  -- language support
  { "bronzehedwick/msmtp-syntax.vim" },
  { "cespare/vim-toml" },
  { "chunkhang/vim-mbsync" },
  { "digitaltoad/vim-pug" },
  { "ekalinin/Dockerfile.vim" },
  { "fladson/vim-kitty" },
  {
    "Fymyte/rasi.vim",
    ft = { "rasi" },
  },
  { "HerringtonDarkholme/yats.vim" },
  { "jparise/vim-graphql" },
  { "jxnblk/vim-mdx-js" },
  { "lifepillar/pgsql.vim" },
  { "MaxMEllon/vim-jsx-pretty" },
  { "mustache/vim-mustache-handlebars" },
  { "neoclide/jsonc.vim" },
  { "neomutt/neomutt.vim" },
  { "othree/html5.vim" },
  { "pangloss/vim-javascript" },
  { "rust-lang/rust.vim" },
  { "tmux-plugins/vim-tmux" },
  { "tpope/vim-git" },
  { "tpope/vim-markdown" },
  { "vitalk/vim-shebang" },
}

return plugins
