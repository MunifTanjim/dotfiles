local mod={}
mod.__index = mod

mod.name = "WindowManager"
mod.version = "0.0.0"
mod.author = "Munif Tanjim"
mod.homepage = ""
mod.license = "MIT (https://opensource.org/licenses/MIT)"

mod.logger = hs.logger.new(mod.name)

mod.sizes = {2, 3, 3/2}

local GRID = { w = 24, h = 24, margins = hs.geometry.point(0, 0) }

local directions = { 'up', 'down', 'left', 'right' }
local direction_data = {
  up    = { reverse = 'down',  dim = 'h', pos = 'y', home = function() return 0          end },
  down  = { reverse = 'up',    dim = 'h', pos = 'y', home = function() return GRID.h end },
  left  = { reverse = 'right', dim = 'w', pos = 'x', home = function() return 0          end },
  right = { reverse = 'left',  dim = 'w', pos = 'x', home = function() return GRID.w end }
}

local last_size_index_by_direction = {}

local function round(num)
  if num >= 0 then
    return math.floor(num+.499999999)
  else
    return math.ceil(num-.499999999)
  end
end

local function frontmost_window()
  return hs.window.frontmostWindow()
end

local function frontmost_cell()
  local win = frontmost_window()
  return hs.grid.get(win, win:screen())
end

local function set_position(cell)
  local win = frontmost_window()
  hs.grid.set(win, cell, win:screen())
end

--- snap cell to grid
local function snap_to_grid(cell)
  hs.fnutils.each({'h', 'w', 'x', 'y'}, function(d)
    cell[d] = round(cell[d])
  end)
  return cell
end

--- grow window to full dimension (width/height)
local function grow_full_dimension(dimension)
  local cell = frontmost_cell()
  cell[dimension == 'h' and 'y' or 'x'] = 0
  cell[dimension] = GRID[dimension]
  set_position(cell)
end

-- check if window is at screen edge
local function is_at_edge(direction)
  local cell = frontmost_cell()
  if direction == 'up' then
    return cell.y == 0
  elseif direction == 'down' then
    return cell.y + cell.h == GRID.h
  elseif direction == 'left' then
    return cell.x == 0
  elseif direction == 'right' then
    return cell.x + cell.w == GRID.w
  end
end

--- get current size index
local function get_current_size_index(direction)
  if not is_at_edge(direction) then
    return 0
  end

  local last_index = last_size_index_by_direction[direction]

  if not last_index or not mod.sizes[last_index] then
    return 0
  end

  local dim = direction_data[direction].dim
  local length = frontmost_cell()[dim]
  local relative_size = GRID[dim] / length

  if mod.sizes[last_index] == relative_size then 
    return last_size_index_by_direction[direction]
  end

  last_size_index_by_direction[direction] = nil

  return hs.fnutils.indexOf(mod.sizes, relative_size) or 0
end

local function set_to_size(direction, index)
  local cell = frontmost_cell()

  cell[direction_data[direction].dim] = GRID[direction_data[direction].dim] / mod.sizes[index]

  if direction == 'left' or direction == 'up' then
    cell[direction_data[direction].pos] = direction_data[direction].home()
  else
    cell[direction_data[direction].pos] = direction_data[direction].home() - cell[direction_data[direction].dim]
  end

  cell = snap_to_grid(cell)

  set_position(cell)

  last_size_index_by_direction[direction] = index
end

--- set grid width and height
function mod:set_grid(width, height)
  GRID.w = width
  GRID.h = height
  hs.grid.setGrid(width..'x'..height)
  return self
end

--- set grid margins
function mod:set_margins(margins)
  GRID.margins = margins
  hs.grid.setMargins(margins)
  return self
end

--- move and/or resize window in specific direction
function mod:go(direction)
  local cell = frontmost_cell()
  local index = get_current_size_index(direction)
  index = index % #self.sizes + 1
  set_to_size(direction, index)
  return self
end

--- move window to center
function mod:center()
  local cell = frontmost_cell()
  cell.center = hs.geometry(GRID.margins, hs.geometry.size(GRID.w, GRID.h)).center
  set_position(cell)
  return self
end

function mod:bindHotkeys(mapping)
  local reverse_direction_modals = {}

  for _, direction in ipairs(directions) do
    local modal = hs.hotkey.modal.new()

    function modal.entered() self.logger.d(direction.." modal entered") end
    function modal.exited()  self.logger.d(direction.." modal exited")  end

    if mapping[direction] and mapping[direction_data[direction].reverse] then
      modal:bind(
        mapping[direction][1],
        mapping[direction_data[direction].reverse][2],
        function()
          grow_full_dimension(direction_data[direction].dim)
        end
      )

      reverse_direction_modals[direction] = modal
    end
  end

  for _, direction in ipairs(directions) do
    if mapping[direction] then
      hs.hotkey.bind(
        mapping[direction][1],
        mapping[direction][2],
        function()
          reverse_direction_modals[direction]:enter()
          self:go(direction)
        end,
        function()
          reverse_direction_modals[direction]:exit()
        end
      )
    end
  end

  if mapping.center then
    hs.hotkey.bind(
      mapping.center[1],
      mapping.center[2],
      function()
        self:center()
      end
    )
  end
end

function mod:init()
  self.logger.i("Loading ".. self.name)
end

return mod

--- inspiration: https://github.com/miromannino/miro-windows-manager
