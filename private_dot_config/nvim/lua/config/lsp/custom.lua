local Input = require("nui.input")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local mod = {}

function mod.rename()
  local curr_name = vim.fn.expand("<cword>")

  local params = vim.lsp.util.make_position_params()

  local function on_submit(new_name)
    if not new_name or #new_name == 0 or curr_name == new_name then
      return
    end

    params.newName = new_name

    vim.lsp.buf_request(0, "textDocument/rename", params, function(_, result, _, _)
      if not result then
        return
      end

      local total_files = vim.tbl_count(result.changes)

      vim.lsp.util.apply_workspace_edit(result)

      print(string.format("Changed %s file%s. To save them run ':wa'", total_files, total_files > 1 and "s" or ""))
    end)
  end

  local input = Input({
    border = {
      style = "rounded",
      highlight = "Normal",
      text = {
        top = "[Rename]",
        top_align = "left",
      },
    },
    highlight = "Normal:Normal",
    relative = {
      type = "buf",
      position = {
        row = params.position.line,
        col = params.position.character,
      },
    },
    position = {
      row = 1,
      col = 0,
    },
    size = {
      width = 25,
      height = 1,
    },
  }, {
    prompt = "",
    default_value = curr_name,
    on_submit = on_submit,
  })

  input:mount()

  input:on(event.BufLeave, input.input_props.on_close, { once = true })

  input:map("n", "<esc>", input.input_props.on_close, { noremap = true })
end

local select_menu = nil

vim.ui.select = function(items, opts, on_choice)
  if select_menu then
    error("Busy!")
  end

  local max_length = vim.api.nvim_win_get_width(0)

  opts = opts or {}

  local format_item = opts.format_item or tostring

  local lines = {}

  for _, item in pairs(items) do
    local item_text = string.sub(format_item(item), 0, max_length - 2)
    table.insert(lines, Menu.item(item_text, item))
  end

  select_menu = Menu({
    relative = "cursor",
    position = {
      row = 1,
      col = 0,
    },
    border = {
      style = "rounded",
      highlight = "Normal",
      text = {
        top = opts.prompt or "[Choose Item]",
        top_align = "left",
      },
    },
    highlight = "Normal:Normal",
  }, {
    lines = lines,
    separator = {
      char = "-",
      text_align = "right",
    },
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      on_choice(nil, nil)
      select_menu = nil
    end,
    on_submit = function(item)
      on_choice(item, item._index)
      select_menu = nil
    end,
  })

  select_menu:mount()
end

return mod
