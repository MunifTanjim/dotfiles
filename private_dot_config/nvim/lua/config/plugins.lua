local packer_fresh_install = nil

local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  packer_fresh_install = vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    packer_path,
  })

  vim.cmd([[packadd packer.nvim]])
end

require("packer").startup({
  function(use)
    use("wbthomason/packer.nvim")

    -- appearance
    use("gruvbox-community/gruvbox")
    use("vim-airline/vim-airline")

    -- functionality
    use("bkad/CamelCaseMotion")
    use({
      "heavenshell/vim-jsdoc",
      ft = {
        "javascript",
        "javascriptreact",
      },
      run = "make install",
    })
    use("junegunn/vim-easy-align")
    use("mhinz/vim-startify")
    use({
      "rrethy/vim-hexokinase",
      run = "make hexokinase",
    })
    use("szw/vim-maximizer")
    use("tpope/vim-capslock")
    use("tpope/vim-repeat")
    use("tpope/vim-sensible")
    use("tpope/vim-surround")
    use("tpope/vim-unimpaired")

    -- integration
    use("christoomey/vim-tmux-navigator")
    use("kristijanhusak/vim-carbon-now-sh")
    use("RyanMillerC/better-vim-tmux-resizer")
    use("wakatime/vim-wakatime")

    -- language support
    use("bronzehedwick/msmtp-syntax.vim")
    use("cespare/vim-toml")
    use("chunkhang/vim-mbsync")
    use("digitaltoad/vim-pug")
    use("ekalinin/Dockerfile.vim")
    use("HerringtonDarkholme/yats.vim")
    use("jparise/vim-graphql")
    use("jxnblk/vim-mdx-js")
    use("lifepillar/pgsql.vim")
    use("MaxMEllon/vim-jsx-pretty")
    use("mustache/vim-mustache-handlebars")
    use("neoclide/jsonc.vim")
    use("neomutt/neomutt.vim")
    use("othree/html5.vim")
    use("pangloss/vim-javascript")
    use("rust-lang/rust.vim")
    use("tmux-plugins/vim-tmux")
    use("tpope/vim-git")
    use("tpope/vim-markdown")
    use("vitalk/vim-shebang")

    use("nvim-lua/plenary.nvim")

    use({
      "MunifTanjim/nui.nvim",
      config = function()
        require("config.plugins.nui")
      end,
    })

    use({
      "MunifTanjim/exrc.nvim",
      config = function()
        require("config.plugins.exrc")
      end,
    })

    ---[[ Git
    use({
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("config.plugins.gitsigns")
      end,
    })
    use("rhysd/git-messenger.vim")
    use("tpope/vim-fugitive")
    ---]]

    ---[[ Completion
    use("github/copilot.vim")

    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-vsnip",
        "onsails/lspkind-nvim",
      },
      config = function()
        require("config.plugins.cmp")
      end,
    })
    ---]]

    ---[[ Snippet
    use({
      "hrsh7th/vim-vsnip",
      requires = {
        "hrsh7th/vim-vsnip-integ",
      },
      config = function()
        require("config.plugins.vsnip")
      end,
    })
    ---]]

    ---[[ LSP
    use({
      "williamboman/mason.nvim",
      config = function()
        require("config.plugins.mason")
      end,
    })
    use({
      "neovim/nvim-lspconfig",
      requires = {
        "b0o/schemastore.nvim",
        "folke/lua-dev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "jose-elias-alvarez/typescript.nvim",
        "MunifTanjim/nui.nvim",
        "onsails/lspkind-nvim",
        {
          "williamboman/mason-lspconfig.nvim",
          requires = {
            "mason.nvim",
          },
        },
      },
      config = function()
        require("config.plugins.lsp")
      end,
    })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = {
        "MunifTanjim/eslint.nvim",
        "MunifTanjim/prettier.nvim",
      },
      config = function()
        require("config.plugins.lsp.null-ls")
      end,
    })
    use({
      "kosayoda/nvim-lightbulb",
      config = function()
        require("config.plugins.lsp.lightbulb")
      end,
    })
    use({
      "folke/trouble.nvim",
      config = function()
        require("config.plugins.lsp.trouble")
      end,
    })
    ---]]

    use({
      "windwp/nvim-autopairs",
      requires = {
        "nvim-cmp",
      },
      config = function()
        require("config.plugins.autopairs")
      end,
    })

    ---[[ TUI
    local fzf_root = vim.fn.fnamemodify(vim.fn.stdpath("data"), ":h") .. "/fzf"
    if vim.fn.isdirectory(fzf_root) == 1 then
      use(fzf_root)
      use("junegunn/fzf.vim")
      use("stsewd/fzf-checkout.vim")
    end

    use({
      "nvim-neo-tree/neo-tree.nvim",
      branch = "main",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker",
      },
      config = function()
        require("config.plugins.neo-tree")
      end,
    })

    use({
      "windwp/nvim-spectre",
      config = function()
        require("config.plugins.spectre")
      end,
    })

    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = "make",
        },
      },
      config = function()
        require("config.plugins.telescope")
      end,
    })
    ---]]

    ---[[ TreeSitter
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "RRethy/nvim-treesitter-textsubjects",
        "nvim-treesitter/playground",
        "windwp/nvim-ts-autotag",
      },
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end,
      config = function()
        require("config.plugins.treesitter")
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require("config.plugins.treesitter.context")
      end,
    })
    use({
      "numToStr/Comment.nvim",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      config = function()
        require("config.plugins.treesitter.comment")
      end,
    })
    ---]]

    ---[[ DAP
    use({
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
      },
      config = function()
        require("config.plugins.dap")
      end,
    })
    ---]]

    use({
      "luukvbaal/stabilize.nvim",
      disable = true,
      config = function()
        require("config.plugins.stabilize")
      end,
    })

    if packer_fresh_install then
      require("packer").sync()
    end
  end,
  config = {
    max_jobs = 8,
  },
})
