local augroup = vim.api.nvim_create_augroup("chezmoi-nvim-lua", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  callback = function(info)
    if vim.fn.fnamemodify(info.file, ":t"):match("^%.") then
      return
    end

    if vim.fn.exists("$TMUX") == 1 then
      vim.fn.systemlist({ "tmux", "display-popup", "-E", "chezmoi apply --exclude templates" })
      return
    end

    if vim.fn.exists(":TermExec") == 2 then
      vim.cmd(":TermExec cmd='chezmoi apply --exclude templates && exit 0' direction=float")
      return
    end

    vim.fn.systemlist({ "chezmoi", "apply", "--exclude", "templates", "--no-tty" })
  end,
})
