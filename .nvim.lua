-- tmux popup
local function try_tmux_popup_exec(cmd)
  if vim.fn.exists("$TMUX") == 1 then
    vim.system({ "tmux", "display-popup", "-EE", table.concat(cmd, " ") }, { text = true })
    return true
  end
end

-- akinsho/toggleterm.nvim
local function try_toggleterm_exec(cmd)
  if vim.fn.exists(":TermExec") == 2 then
    vim.schedule(function()
      vim.cmd("TermExec cmd='" .. table.concat(cmd, " ") .. "&& exit || read -n 1; exit' direction=float")
    end)
    return true
  end
end

local chezmoi_ignored_files = {}
local function is_chezmoi_ignored_file(file)
  if not chezmoi_ignored_files[0] then
    for _, ignored_file in
      ipairs(
        vim.split(
          vim.system({ "chezmoi", "ignored" }, { text = true }):wait().stdout,
          "\n",
          { plain = true, trimempty = true }
        )
      )
    do
      chezmoi_ignored_files[ignored_file] = true
    end
    chezmoi_ignored_files[0] = true
  end

  if chezmoi_ignored_files[file] then
    return true
  end

  local fname = vim.fn.fnamemodify(file, ":.")
  while #fname > 1 do
    if vim.fn.fnamemodify(fname, ":t"):match("^%.") then
      -- starting with `.`
      return true
    end
    fname = vim.fn.fnamemodify(fname, ":h")
  end

  return false
end

--[[ chezmoi ]]
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("chezmoi-nvim-lua", { clear = true }),
  callback = function(info)
    if is_chezmoi_ignored_file(info.file) then
      return
    end

    local chezmoi_apply_cmd = {
      "chezmoi",
      "apply",
      "--parent-dirs",
      vim.fn.systemlist({ "chezmoi", "target-path", info.file })[1],
    }

    if try_tmux_popup_exec(chezmoi_apply_cmd) then
      return
    end

    if try_toggleterm_exec(chezmoi_apply_cmd) then
      return
    end

    if vim.fn.fnamemodify(info.file, ":."):match("%.tmpl$") then
      for _, line in ipairs(vim.api.nvim_buf_get_lines(info.buf, 0, -1, false)) do
        if string.find(line, "bitwarden") then
          -- ignore template files that needs secret
          return
        end
      end
    end

    vim.system(chezmoi_apply_cmd, { text = true }):wait()
  end,
})
