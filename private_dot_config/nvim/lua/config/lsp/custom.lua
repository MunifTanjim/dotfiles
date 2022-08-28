local Input = require("nui.input")
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

    vim.lsp.buf_request(0, "textDocument/rename", params, function(_, result, ctx, _)
      if not result then
        return
      end

      local total_files = vim.tbl_count(result.changes)

      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

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

---@param server_name string
---@param settings_patcher fun(settings: table): table
function mod.patch_lsp_settings(server_name, settings_patcher)
  local function patch_settings(client)
    client.config.settings = settings_patcher(client.config.settings)
    client.notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })
  end

  local clients = vim.lsp.get_active_clients({ name = server_name })
  if #clients > 0 then
    patch_settings(clients[1])
    return
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.name == server_name then
        patch_settings(client)
        return true
      end
    end,
  })
end

---@param offset_encoding 'utf-8'|'utf-16'|'utf-32'
function mod.document_highlight(offset_encoding)
  local params = vim.lsp.util.make_position_params(0, offset_encoding)
  vim.lsp.buf_request(0, "textDocument/documentHighlight", params, nil)
end

return mod
