local u = require("config.utils")

vim.g.neo_tree_remove_legacy_commands = true

require("window-picker").setup({})

local function expand_directory_or_edit_file(state)
  local node = state.tree:get_node()
  if node.type == "directory" then
    if not node:is_expanded() then
      require("neo-tree.sources.filesystem").toggle_directory(state, node)
    elseif node:has_children() then
      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    end
  elseif node.type == "file" then
    require("neo-tree.sources.common.commands").open_with_window_picker(state)
    require("neo-tree").close_all()
  end
end

local function change_global_cwd(state)
  local node = state.tree:get_node()
  if node.type == "directory" then
    vim.cmd("cd " .. node.id)
  end
end

require("neo-tree").setup({
  close_if_last_window = true,
  close_floats_on_escape_key = true,
  default_source = "filesystem",
  enable_diagnostics = false,
  enable_git_status = true,
  git_status_async = true,
  popup_border_style = "rounded",
  resize_timer_interval = -1,
  use_default_mappings = false,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      default = "",
    },
    modified = {
      symbol = "",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
    },
    git_status = {
      align = "left",
      symbols = {
        -- Change type
        added = "+",
        deleted = "⚠",
        modified = "",
        renamed = "→",
        -- Status type
        untracked = "?",
        ignored = "◌",
        unstaged = "✗",
        staged = "✓",
        conflict = "",
      },
    },
  },
  window = {
    position = "right",
    width = 40,
    mappings = {
      ["<C-s>"] = "open_split",
      ["<C-t>"] = "open_tabnew",
      ["<C-v>"] = "open_vsplit",
      ["<CR>"] = "open",
      ["A"] = "add_directory",
      ["a"] = "add",
      ["df"] = "delete",
      ["dd"] = "cut_to_clipboard",
      ["gq"] = "close_window",
      ["gr"] = "refresh",
      ["h"] = "close_node",
      ["<Left>"] = "close_node",
      ["l"] = expand_directory_or_edit_file,
      ["<Right>"] = expand_directory_or_edit_file,
      ["p"] = "paste_from_clipboard",
      ["r"] = "rename",
      -- ["w"] = "open_with_window_picker",
      ["yy"] = "copy_to_clipboard",
    },
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
      },
      never_show = { -- remains hidden even if visible is toggled to true
        --".DS_Store",
        --"thumbs.db"
      },
      show_hidden_count = false,
    },
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    window = {
      mappings = {
        ["<BS>"] = "navigate_up",
        ["<CR>"] = "set_root",
        ["<Leader><CR>"] = change_global_cwd,
        ["g."] = "toggle_dotfiles",
        ["gi"] = "toggle_gitignored",
        ["o"] = "system_open",
        ["[c"] = "prev_git_modified",
        ["]c"] = "next_git_modified",
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.api.nvim_command("silent !open " .. path)
      end,
      toggle_dotfiles = function(state)
        state.filtered_items.visible = false
        state.filtered_items.hide_dotfiles = not state.filtered_items.hide_dotfiles
        require("neo-tree.sources.manager").refresh("filesystem")
      end,
      toggle_gitignored = function(state)
        state.filtered_items.visible = false
        state.filtered_items.hide_gitignored = not state.filtered_items.hide_gitignored
        require("neo-tree.sources.manager").refresh("filesystem")
      end,
    },
    renderers = {
      directory = {
        { "indent" },
        { "icon" },
        -- { "diagnostics", errors_only = true },
        { "current_filter" },
        { "name" },
        { "clipboard" },
      },
      file = {
        { "indent" },
        { "icon" },
        -- { "diagnostics" },
        { "git_status" },
        { "name", use_git_status_colors = true },
        { "clipboard" },
        { "bufnr" },
        { "modified" },
      },
    },
  },
})

u.set_keymap("n", "<Leader>e", ":Neotree toggle<CR>", "toggle file tree")
