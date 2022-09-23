local mod = {}

local u = require("config.utils")
local async = require("plenary.async")
local api = require("copilot.api")
local util = require("copilot.util")

-- { {
--     displayText = "function add(a, b)\n  return a + b\nend",
--     position = {
--       character = 0,
--       line = 194
--     },
--     range = {
--       ["end"] = {
--         character = 0,
--         line = 194
--       },
--       start = {
--         character = 0,
--         line = 194
--       }
--     },
--     text = "function add(a, b)\n  return a + b\nend",
--     uuid = "3b71def6-838f-4947-a8c2-5cb33fea8f54"
--   } }

local config = {
  mapping = {
    accept = "<CR>",
  },
}

local namespace_id = nil
local suggested_completion = nil

local function get_completion()
  local client = vim.lsp.get_active_clients({ name = "copilot" })
  if not client then
    print("Copilot client not attached, check :LspInfo")
    return
  end

  local params = cutil.get_doc_params({
    doc = { insertSpaces = false },
  })

  local result = async.wrap(vim.lsp.buf_request_all, 4)(0, "getCompletionsCycling", params)

  local completions = {}

  for _, part in ipairs(result) do
    if part.result ~= nil then
      table.insert(completions, part.result.completions[1])
    end
  end

  return completions
end

local function show_copilot_waiting()
  print("Waiting for Copilot Language Server...")
end

local function hide_copilot_waiting(is_success)
  if is_success then
    print("Done!")
  else
    print("No completions found.")
  end
end

local function show_ghost_completion(completion)
  local display_text = completion.displayText

  local completion_params = util.get_completion_params()
  completion_params.doc.insertSpaces = false

  local lines = {}

  for s, _ in display_text:gmatch("[^\n]+") do
    table.insert(lines, {
      {
        s,
        "CopilotSuggestion",
      },
    })
  end

  -- BUG: This still doesn't work all the time
  local first_line = table.remove(lines, 1)
  if first_line[1][1]:find("^\t") ~= nil then
    first_line[1][1] = first_line[1][1]:sub(2)
  end

  local bnr = vim.fn.bufnr("%")
  namespace_id = vim.api.nvim_create_namespace("copilot-client")

  local line_num = completion_params.doc.position.line
  local col_num = completion_params.doc.position.character

  local opts = {
    id = 1,
    virt_text = first_line,
    virt_lines = lines,
    virt_text_pos = "overlay",
    virt_text_win_col = completion.position.character + 1,
    right_gravity = false,
  }

  vim.api.nvim_buf_set_extmark(bnr, namespace_id, line_num, col_num, opts)
end

local function clear_ghost_completion()
  vim.api.nvim_buf_clear_namespace(0, namespace_id, 0, -1)
end

local function create_keymaps(opts)
  vim.api.nvim_buf_set_keymap(
    0,
    "i",
    opts.mapping.accept,
    '<cmd>lua require("config.copilot").accept()<CR>',
    { noremap = true, silent = false }
  )
end

-- PERF: Delete keymap if it exists without looking at all other buffer keymaps
local function delete_keymaps(opts)
  local buf_keymaps = vim.api.nvim_buf_get_keymap(0, "i")
  for _, keymap in pairs(buf_keymaps) do
    if keymap.lhs == opts.mapping.accept then
      vim.api.nvim_buf_del_keymap(0, "i", opts.mapping.accept)
      break
    end
  end
end

local function create_autocmds(opts)
  local augroup = vim.api.nvim_create_augroup("CopilotClient", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    group = augroup,
    callback = function()
      delete_keymaps(opts)
    end,
    once = true,
  })

  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChangedI", "CursorMovedI" }, {
    group = augroup,
    callback = function()
      clear_ghost_completion()
    end,
    once = true,
  })
end

function mod.suggest()
  async.run(function()
    local is_insert_mode = vim.api.nvim_get_mode().mode == "i"
    if not is_insert_mode then
      print("You have to be in insert mode when calling 'suggest'")
      return
    end

    show_copilot_waiting()

    local completions = get_completion() or {}
    if next(completions) == nil then
      hide_copilot_waiting(false)
      return
    end

    -- TODO: Handle multiple completions
    local first_completion = completions[1]
    suggested_completion = first_completion

    hide_copilot_waiting(true)
    show_ghost_completion(first_completion)

    create_keymaps(config)
    create_autocmds(config)
  end, function(...)
    print(vim.inspect({ ... }))
  end)
end

local function insert_completion(completion)
  local display_text = completion.displayText

  local lines = {}
  for s, _ in display_text:gmatch("[^\n]+") do
    table.insert(lines, s)
  end

  if lines[1]:find("^\t") ~= nil then
    lines[1] = lines[1]:sub(2)
  end

  vim.api.nvim_put(lines, "c", true, true)
end

function mod.accept()
  insert_completion(suggested_completion)
  delete_keymaps(config)
end

function mod.setup()
  --[[
  u.set_keymap("i", "<C-p>", function()
  end, "[copilot] suggest")
  ]]
end

-- add two numbers

return mod
