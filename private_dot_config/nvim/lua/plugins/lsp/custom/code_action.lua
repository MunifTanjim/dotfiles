local Menu = require("nui.menu")

local code_action_kinds = {
  Menu.item("Empty", { value = "" }),
  Menu.item("QuickFix", { value = "quickfix" }),
  Menu.item("Refactor", { value = "refactor" }),
  Menu.item("RefactorExtract", { value = "refactor.extract" }),
  Menu.item("RefactorInline", { value = "refactor.inline" }),
  Menu.item("RefactorRewrite", { value = "refactor.rewrite" }),
  Menu.item("Source", { value = "source" }),
  Menu.item("SourceFixAll", { value = "source.fixAll" }),
  Menu.item("SourceOrganizeImports", { value = "source.organizeImports" }),
}

---@param on_done fun(kind?: string): nil
local function select_code_action_kind(on_done)
  local menu = Menu({
    relative = "cursor",
    position = {
      row = 2,
      col = 1,
    },
    border = {
      style = "rounded",
      text = {
        top = "[Code Action Kind]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  }, {
    lines = code_action_kinds,
    on_close = function()
      on_done()
    end,
    on_submit = function(item)
      on_done(item.value)
    end,
  })

  menu:mount()
end

---@param kind? string|string[]|true
local function code_action(kind)
  if not kind then
    vim.lsp.buf.code_action()
    return
  end

  local function open_code_actions(only)
    only = type(only) == "string" and { only } or only
    vim.lsp.buf.code_action({ context = { only = only, diagnostics = {}, triggerKind = 1 } })
  end

  if kind ~= true then
    open_code_actions(kind)
    return
  end

  select_code_action_kind(function(only)
    if only then
      open_code_actions(only)
    end
  end)
end

return code_action
