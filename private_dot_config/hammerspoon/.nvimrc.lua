require("config.lsp.custom").patch_lsp_settings("sumneko_lua", function(settings)
  settings.Lua.diagnostics.globals = { "hs", "spoon" }

  settings.Lua.workspace.library = {}

  local hammerspoon_emmpylua_annotations = vim.fn.expand("~/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations")
  if vim.fn.isdirectory(hammerspoon_emmpylua_annotations) == 1 then
    table.insert(settings.Lua.workspace.library, hammerspoon_emmpylua_annotations)
  end

  return settings
end)
