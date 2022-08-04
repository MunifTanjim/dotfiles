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
    use({ "heavenshell/vim-jsdoc", ft = { "javascript", "javascriptreact" }, run = "make install" })
    use("junegunn/vim-easy-align")
    use("mhinz/vim-startify")
    use({ "rrethy/vim-hexokinase", run = "make hexokinase" })
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
        require("config.ui").override_input()
        require("config.ui").override_select()
      end,
    })

    use({
      "MunifTanjim/exrc.nvim",
      config = function()
        vim.o.exrc = false
        require("exrc").setup()
      end,
    })

    ---[[ Git
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
          signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "▁" },
            topdelete = { text = "▔" },
            changedelete = { text = "▎" },
          },
          on_attach = function(bufnr)
            local function set_keymap(mode, lhs, rhs, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, lhs, rhs, opts)
            end

            set_keymap("n", "[c", function()
              if vim.wo.diff then
                return "[c"
              end

              vim.schedule(function()
                gitsigns.prev_hunk()
              end)
              return "<ignore>"
            end, { expr = true })

            set_keymap("n", "]c", function()
              if vim.wo.diff then
                return "]c"
              end

              vim.schedule(function()
                gitsigns.next_hunk()
              end)

              return "<ignore>"
            end, { expr = true })

            set_keymap("v", "<leader>gs", ":Gitsigns stage_hunk<cr>")
          end,
        })

        vim.schedule(function()
          vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GruvboxOrangeSign" })
        end)
      end,
    })
    use("rhysd/git-messenger.vim")
    use("tpope/vim-fugitive")
    ---]]

    ---[[ Completion
    use("github/copilot.vim")

    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-vsnip")
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "onsails/lspkind-nvim",
      },
      config = function()
        require("config.completion")
      end,
    })
    ---]]

    ---[[ Snippet
    use({
      "hrsh7th/vim-vsnip",
      config = function()
        require("config.snippet")
      end,
    })
    use("hrsh7th/vim-vsnip-integ")
    ---]]

    ---[[ LSP
    use({
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup({
          ui = {
            border = "rounded",
          },
        })
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
          requires = { "mason.nvim" },
        },
      },
      config = function()
        require("config.lsp")
      end,
    })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("config.lsp.null-ls")
      end,
    })
    use({
      "MunifTanjim/eslint.nvim",
      after = { "null-ls.nvim" },
      config = function()
        local eslint = require("eslint")
        eslint.setup({
          bin = "eslint_d",
        })
      end,
    })
    use({
      "MunifTanjim/prettier.nvim",
      after = { "null-ls.nvim" },
      config = function()
        local prettier = require("prettier")
        prettier.setup({
          bin = "prettier",
        })
      end,
    })
    use({
      "kosayoda/nvim-lightbulb",
      config = function()
        vim.fn.sign_define("LightBulbSign", {
          text = "",
          texthl = "DiagnosticSignHint",
        })

        require("nvim-lightbulb").setup({
          sign = {
            enabled = true,
            priority = 10,
          },
          autocmd = {
            enabled = true,
            pattern = { "*" },
            events = { "CursorHold", "CursorHoldI" },
          },
        })
      end,
    })
    use({
      "folke/trouble.nvim",
      config = function()
        local trouble = require("trouble")

        trouble.setup({
          action_keys = {
            close = "gq",
          },
        })

        vim.keymap.set("n", "<Leader>xx", ":TroubleToggle<CR>", { silent = true })
      end,
    })
    ---]]

    use({
      "windwp/nvim-autopairs",
      requires = {
        "nvim-cmp",
      },
      config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
          disable_filetype = { "TelescopePrompt" },
          disable_in_macro = false,
          ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
          enable_moveright = true,
          enable_afterquote = true,
          enable_check_bracket_line = true,
          check_ts = false,
          map_bs = true,
          map_c_w = false,
        })

        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on(
          "confirm_done",
          cmp_autopairs.on_confirm_done({
            map_char = {
              sh = "",
            },
          })
        )
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
        require("config.neo-tree")
      end,
    })

    use({
      "windwp/nvim-spectre",
      config = function()
        vim.cmd("nnoremap <Leader>S :lua require('spectre').open()<CR>")
      end,
    })

    use({
      "nvim-telescope/telescope.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.telescope")
      end,
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
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
        require("config.treesitter")
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup({
          max_lines = 2,
          trim_scope = "outer",
          patterns = {
            default = {
              "class",
              "function",
              "method",
            },
          },
          exact_patterns = {},
        })

        vim.keymap.set("n", "<Leader>tsc", "<cmd>TSContextToggle<CR>")

        vim.schedule(function()
          vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
          vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "CursorLine" })
        end)
      end,
    })
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup({
          pre_hook = function(ctx)
            -- Only calculate commentstring for tsx filetypes
            if vim.bo.filetype == "typescriptreact" then
              local U = require("Comment.utils")

              -- Detemine whether to use linewise or blockwise commentstring
              local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

              -- Determine the location where to calculate commentstring from
              local location = nil
              if ctx.ctype == U.ctype.block then
                location = require("ts_context_commentstring.utils").get_cursor_location()
              elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require("ts_context_commentstring.utils").get_visual_start_location()
              end

              return require("ts_context_commentstring.internal").calculate_commentstring({
                key = type,
                location = location,
              })
            end
          end,
        })
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
        require("config.dap")
      end,
    })
    ---]]

    use({
      "luukvbaal/stabilize.nvim",
      disable = true,
      config = function()
        require("stabilize").setup({
          force = false,
        })
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
