local u = {}

local local_git_dir = vim.fn.expand("$HOME/Dev")
local git_host_by_provider = {
  github = "github.com",
  gitlab = "gitlab.com",
}

function u.dev_plugin(spec)
  if type(spec) == "string" then
    spec = { spec }
  end

  local git_provider = spec.git_provider
  if not git_provider or not git_host_by_provider[git_provider] then
    git_provider = "github"
  end

  local plugin_dir = string.format("%s/%s/%s", local_git_dir, git_provider, spec[1])
  local plugin_url = string.format("https://%s/%s", git_host_by_provider[git_provider], spec[1])
  if not vim.loop.fs_stat(plugin_dir) then
    local output = vim.fn.system({ "git", "clone", plugin_url, plugin_dir })
    if vim.v.shell_error ~= 0 then
      vim.notify(output, vim.log.levels.ERROR)
    end
  end

  spec.dev = true
  spec.dir = plugin_dir
  spec.url = plugin_url

  return spec
end

---@param server_name string
---@param settings_patcher fun(settings: table): table
function u.patch_lsp_settings(server_name, settings_patcher)
  local function patch_settings(client)
    client.config.settings = settings_patcher(client.config.settings)
    client.notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })
  end

  local clients = vim.lsp.get_clients({ name = server_name })
  if #clients > 0 then
    patch_settings(clients[1])
    return
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == server_name then
        patch_settings(client)
        return true
      end
    end,
  })
end

---@param mode string|string[]
---@param lhs string
---@param rhs string|fun():nil
---@param desc_or_opts string|table
---@param opts? table
function u.set_keymap(mode, lhs, rhs, desc_or_opts, opts)
  if not opts then
    opts = type(desc_or_opts) == "table" and desc_or_opts or { desc = desc_or_opts }
  else
    opts.desc = desc_or_opts
  end
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts, { silent = true }))
end

---@param default_mode string|string[]
---@param maps ({[1]: string, [2]: string|(fun():nil), [3]?: string|table, [4]?: table}|table)[]
---@param fallback_opts? table
function u.set_keymaps(default_mode, maps, fallback_opts)
  fallback_opts = fallback_opts or {}
  for _, map in ipairs(maps) do
    local mode, lhs, rhs, desc, opts = map.mode or default_mode, map[1], map[2], map[3], map[4]
    if not opts then
      opts = type(desc) == "table" and desc or { desc = desc }
    else
      opts.desc = desc
    end
    map.mode, map[1], map[2], map[3], map[4] = nil, nil, nil, nil, nil
    local ops = vim.tbl_extend("keep", map, opts, fallback_opts, { silent = true })
    u.set_keymap(mode, lhs, rhs, ops)
  end
end

return u
