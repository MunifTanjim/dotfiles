vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ":~"
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 0
vim.g.nvim_tree_icon_padding = " "
vim.g.nvim_tree_symlink_arrow = " ➛ "
vim.g.nvim_tree_respect_buf_cwd = 0
vim.g.nvim_tree_create_in_closed_folder = 0
vim.g.nvim_tree_refresh_wait = 1000

local tree_cb = require("nvim-tree.config").nvim_tree_callback

local mapping_list = {
  { key = "l", cb = tree_cb("edit") },
  { key = "<CR>", cb = tree_cb("cd") },
  { key = "<C-v>", cb = tree_cb("vsplit") },
  { key = "<C-s>", cb = tree_cb("split") },
  { key = "<C-t>", cb = tree_cb("tabnew") },
  { key = "{", cb = tree_cb("prev_sibling") },
  { key = "}", cb = tree_cb("next_sibling") },
  { key = "<", cb = tree_cb("parent_node") },
  { key = "h", cb = tree_cb("close_node") },
  { key = "gp", cb = tree_cb("preview") },
  { key = "[[", cb = tree_cb("first_sibling") },
  { key = "]]", cb = tree_cb("last_sibling") },
  { key = "gi", cb = tree_cb("toggle_git_ignored") },
  { key = "g.", cb = tree_cb("toggle_dotfiles") },
  { key = "gr", cb = tree_cb("refresh") },
  { key = "a", cb = tree_cb("create") },
  { key = "dF", cb = tree_cb("remove") },
  { key = "r", cb = tree_cb("rename") },
  { key = "R", cb = tree_cb("full_rename") },
  { key = "dd", cb = tree_cb("cut") },
  { key = "yy", cb = tree_cb("copy") },
  { key = "p", cb = tree_cb("paste") },
  { key = "yn", cb = tree_cb("copy_name") },
  { key = "yp", cb = tree_cb("copy_path") },
  { key = "yP", cb = tree_cb("copy_absolute_path") },
  { key = "[c", cb = tree_cb("prev_git_item") },
  { key = "]c", cb = tree_cb("next_git_item") },
  { key = "<BS>", cb = tree_cb("dir_up") },
  { key = "o", cb = tree_cb("system_open") },
  { key = "gq", cb = tree_cb("close") },
  { key = "g?", cb = tree_cb("toggle_help") },
}

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = false,
  },
  filters = {
    dotfiles = true,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  view = {
    width = 40,
    hide_root_folder = false,
    side = "left",
    mappings = {
      custom_only = true,
      list = mapping_list,
    },
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    },
  },
})

vim.cmd([[
  nnoremap <silent> <Leader>e :NvimTreeToggle<CR>

  highlight NvimTreeFolderIcon guibg=green
]])
