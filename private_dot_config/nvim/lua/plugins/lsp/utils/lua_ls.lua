---@type table<string,string>
local _nvim_lib_dir_store = nil

---@param lib_path_pattern string
---@return table<string, string>
local function get_nvim_lib_dir_map(lib_path_pattern)
  local lib_dir_map = {}

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

  ---@type LazyPlugin[]
  local plugins = require("lazy").plugins()
  for _, plugin in ipairs(plugins) do
    if vim.fn.isdirectory(plugin.dir .. "/lua") == 1 then
      _nvim_lib_dir_store[plugin.name] = plugin.dir
    end
  end
end

---@param package_name string
---@return string|nil lib_dir
local function get_nvim_lib_dir(package_name)
  if not _nvim_lib_dir_store then
    populate_nvim_lib_dir_store()
  end

  return _nvim_lib_dir_store[package_name]
end

---@param packages? string[]
---@return string[]
local function get_nvim_lib_dirs(packages)
  if not _nvim_lib_dir_store then
    populate_nvim_lib_dir_store()
  end

  if not packages then
    packages = vim.tbl_keys(_nvim_lib_dir_store)
  end

  local lib_dirs = {}

  for _, package_name in ipairs(packages) do
    if package_name ~= "neodev.nvim" then
      local lib_dir = _nvim_lib_dir_store[package_name]
      if lib_dir then
        table.insert(lib_dirs, lib_dir)
      end
    end
  end

  return lib_dirs
end

local function read_luarc()
  local luarc_path = vim.fn.fnamemodify(".luarc.lua", ":p")
  if vim.fn.filereadable(luarc_path) == 1 then
    return loadstring(table.concat(vim.fn.readfile(luarc_path), "\n"))() or {}
  end
  return {}
end

local function to_directory_list(paths)
  return vim.tbl_filter(
    function(path)
      return vim.fn.isdirectory(path) == 1
    end,
    vim.tbl_map(function(path)
      return vim.fn.expand(path)
    end, paths or {})
  )
end

local function prepare_workspace_library(luarc)
  local library = {}

  if luarc.workspace then
    vim.list_extend(library, to_directory_list(luarc.workspace.library))
  end

  if luarc.nvim or not luarc.workspace then
    table.insert(
      library,
      get_nvim_lib_dir("neodev.nvim") .. "/types/" .. (vim.version().prerelease and "nightly" or "stable")
    )
    vim.list_extend(library, get_nvim_lib_dirs(luarc.nvim and luarc.nvim.packages))
  end

  return library
end

local mod = {}

function mod.prepare_config(config)
  local luarc = read_luarc()
  if luarc.Lua then
    luarc = luarc.Lua
  end

  config.settings = {
    Lua = vim.tbl_deep_extend(
      "force",
      {
        format = {
          enable = false,
        },
        runtime = {
          version = "LuaJIT",
          path = { "?.lua", "?/init.lua", "lua/?.lua", "lua/?/init.lua" },
          pathStrict = false,
        },
        workspace = {
          checkThirdParty = false,
          maxPreload = 10000,
          preloadFileSize = 10000,
        },
        telemetry = {
          enable = false,
        },
      },
      luarc,
      {
        workspace = {
          library = prepare_workspace_library(luarc),
        },
      }
    ),
  }

  config.settings.Lua.nvim = nil
end

return mod
