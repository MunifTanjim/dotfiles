local lua_workspace_library = {
  vim.fn.expand("$VIMRUNTIME/lua"),
}

for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
  if string.sub(path, -12) == "lua-dev.nvim" then
    table.insert(lua_workspace_library, path .. "/types")
  else
    local lua_path = path .. "/lua"
    if vim.fn.isdirectory(lua_path) == 1 then
      table.insert(lua_workspace_library, lua_path)
    end
  end
end

vim.api.nvim_call_function("coc#config", {
  "Lua.workspace.library",
  lua_workspace_library,
})
