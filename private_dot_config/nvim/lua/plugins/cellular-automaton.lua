local plugin = {
  "Eandrju/cellular-automaton.nvim",
  cmd = "CellularAutomaton",
}

function plugin.init()
  local u = require("config.utils")

  u.set_keymap("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", "FML! Make it rain...")
end

function plugin.config()
  local ca = require("cellular-automaton")

  ca.register_animation({
    fps = 50,
    name = "slide",
    init = function(grid) end,
    update = function(grid)
      for i = 1, #grid do
        local prev = grid[i][#grid[i]]
        for j = 1, #grid[i] do
          grid[i][j], prev = prev, grid[i][j]
        end
      end
      return true
    end,
  })
end

return plugin
