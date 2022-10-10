local mod = {}

---@type table<string,string>
local _nvim_lib_dir_store = nil

---@param lib_path_pattern string
---@return table<string, string>
local function get_nvim_lib_dir_map(lib_path_pattern)
  local lib_dir_map = {}

  ---@diagnostic disable-next-line: param-type-mismatch
  for _, lib_lua_path in ipairs(vim.fn.expand(lib_path_pattern .. "/lua", false, true)) do
    lib_lua_path = vim.loop.fs_realpath(lib_lua_path)

    if lib_lua_path then
      local lib_dir = vim.fn.fnamemodify(lib_lua_path, ":h")
      local lib_name = vim.fn.fnamemodify(lib_dir, ":t")
      lib_dir_map[lib_name] = lib_dir
    end
  end

  return lib_dir_map
end

local function populate_nvim_lib_dir_store()
  _nvim_lib_dir_store = {}

  for lib_name, lib_dir in pairs(get_nvim_lib_dir_map("$VIMRUNTIME")) do
    _nvim_lib_dir_store[lib_name] = lib_dir
  end

  for _, packpath in ipairs(vim.split(vim.o.packpath, ",", { plain = true, trimempty = true })) do
    for _, lib_path_pattern in ipairs({ packpath .. "/pack/*/opt/*", packpath .. "/pack/*/start/*" }) do
      for lib_name, lib_dir in pairs(get_nvim_lib_dir_map(lib_path_pattern)) do
        _nvim_lib_dir_store[lib_name] = lib_dir
      end
    end
  end
end

---@param package_name string
---@return string|nil lib_dir
function mod.get_nvim_lib_dir(package_name)
  if not _nvim_lib_dir_store then
    populate_nvim_lib_dir_store()
  end

  return _nvim_lib_dir_store[package_name]
end

---@param packages? string[]
---@return string[]
function mod.get_nvim_lib_dirs(packages)
  if not _nvim_lib_dir_store then
    populate_nvim_lib_dir_store()
  end

  if not packages then
    return vim.tbl_values(_nvim_lib_dir_store)
  end

  local lib_dirs = {}

  if packages then
    for _, package_name in ipairs(packages) do
      local lib_dir = _nvim_lib_dir_store[package_name]
      if lib_dir then
        table.insert(lib_dirs, lib_dir)
      end
    end
  end

  return lib_dirs
end

function mod.read_luarc()
  local config_file_path = vim.fn.fnamemodify(".luarc.json", ":p")
  if vim.fn.filereadable(config_file_path) == 1 then
    return vim.json.decode(table.concat(vim.fn.readfile(config_file_path), "\n"))
  end
  return {}
end

return mod
