local plugin = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  lazy = true,
  config = function()
    require("plugins.dap.base")
  end,
}

function plugin.init()
  local u = require("config.utils")

  u.set_keymaps("n", {
    {
      "<Leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      "[dap] Breakpoint",
    },
    {
      "<Leader>dB",
      function()
        local condition = vim.fn.input("Breakpoint condition: ")
        local hit_condition = vim.fn.input("Breakpoint hit condition: ")
        local log_message = vim.fn.input("Breakpoint log message: ")
        require("dap").set_breakpoint(condition, hit_condition, log_message)
      end,
      "[dap] Conditional Breakpoint",
    },
    {
      "<Leader>dc",
      function()
        require("dap").continue()
      end,
      "[dap] Continue",
    },
    {
      "<Leader>dp",
      function()
        require("dap").pause()
      end,
      "[dap] Pause",
    },
    {
      "<Leader>dt",
      function()
        require("dap").terminate()
      end,
      "[dap] Terminate",
    },
    {
      "<Leader>di",
      function()
        require("dap").step_into()
      end,
      "[dap] Step Into",
    },
    {
      "<Leader>do",
      function()
        require("dap").step_out()
      end,
      "[dap] Step Out",
    },
    {
      "<Leader>dO",
      function()
        require("dap").step_over()
      end,
      "[dap] Step Over",
    },
    {
      "<Leader>drc",
      function()
        require("dap").run_to_cursor()
      end,
      "[dap] Run to Cursor",
    },
    {
      "<Leader>dh",
      function()
        require("dapui").eval()
      end,
      "[dap] Eval",
    },
  })
end

return plugin
