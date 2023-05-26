local plugin = {
  -- "ruifm/gitlinker.nvim",
  "MunifTanjim/gitlinker.nvim",
  branch = "patched",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "BufReadPost",
}
function plugin.config()
  local function detect_git_remote()
    local gh_default_repo = vim.fn.system({
      "gh",
      "repo",
      "view",
      "--json=nameWithOwner",
      "--template={{.nameWithOwner}}",
    })

    local remotes = vim.fn.systemlist({ "git", "remote", "-v" })
    for _, remote in ipairs(remotes) do
      local name, url = string.match(remote, "(.+)\t(.+) %((.+)%)")
      if string.find(url, gh_default_repo, 1, true) then
        return name
      end
    end
  end

  local function get_remote()
    local remote = vim.t.gitlinker_remote_override
    if remote == nil then
      local ok, value = pcall(detect_git_remote)
      remote = ok and value or false
      vim.t.gitlinker_remote_override = remote
    end
    return remote
  end

  require("gitlinker").setup({
    opts = {
      mappings = false,
      remote = get_remote,
    },
  })

  require("config.utils").set_keymaps("n", {
    {
      "<Leader>gy",
      function()
        require("gitlinker").get_buf_range_url("n")
      end,
      "[git] generate file link",
    },
    {
      "<Leader>gy",
      function()
        require("gitlinker").get_buf_range_url("v")
      end,
      "[git] generate file link",
      mode = "v",
    },
  })
end

return plugin
