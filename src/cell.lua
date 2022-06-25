---@class Cell
---@field id string
---@field rot number
---@field data table
---@field updated boolean
---@param id string
---@param rot number
---@param data table
---@return Cell
function Cell(id, rot, data)
  return {
    id = id,
    rot = rot,
    data = data,
    updated = false,
  }
end

BindCommand("set-cell", function(args)
  ---@diagnostic disable-next-line: undefined-field
  if Grid.setCellCmd then return Grid:setCellCmd(args) end
  if not Grid then return print("No grid found.") end
  local x = tonumber(args[1])
  if not x then return print("X coordinate is not a number.") end
  local y = tonumber(args[2])
  if not y then return print("Y coordinate is not a number.") end

  if not Grid:inside(x, y) then return print("Cell out of bounds.") end

  local id = args[3]
  if not id then return print("ID field does not exist.") end
  local rot = tonumber(args[4])
  if not rot then return print("Rotation field is not a number.") end

  rot = rot % 4

  local cell = Cell(id, rot, {})

  Grid:set(x, y, cell)
end)

BindCommand("get-cell", function(args)
  ---@diagnostic disable-next-line: undefined-field
  if Grid.getCellCmd then return Grid:getCellCmd(args) end
  if not Grid then return print("No grid found.") end
  local x = tonumber(args[1])
  if not x then return print("X coordinate is not a number.") end
  local y = tonumber(args[2])
  if not y then return print("Y coordinate is not a number.") end

  if not Grid:inside(x, y) then
    return print("Cell out of bounds.")
  end
  local c = Grid:at(x, y)

  print("[ Cell ]")
  print("X: " .. x)
  print("Y: " .. y)
  print("ID: " .. c.id)
  print("ROT: " .. c.rot)
end)

BindCommand("set-bg", function(args)
  ---@diagnostic disable-next-line: undefined-field
  if Grid.setBgCmd then return Grid:etBgCmd(args) end
  if not Grid then return print("No grid found.") end
  local x = tonumber(args[1])
  if not x then return print("X coordinate is not a number.") end
  local y = tonumber(args[2])
  if not y then return print("Y coordinate is not a number.") end

  if not Grid:inside(x, y) then return print("Background out of bounds.") end

  local id = args[3]
  if not id then return print("ID field does not exist.") end
  local rot = tonumber(args[4])
  if not rot then return print("Rotation field is not a number.") end

  local cell = Cell(id, rot, {})

  Grid:setBackground(x, y, cell)
end)

BindCommand("get-bg", function(args)
  ---@diagnostic disable-next-line: undefined-field
  if Grid.getBgCmd then return Grid:getBgCmd(args) end
  if not Grid then return print("No grid found.") end
  local x = tonumber(args[1])
  if not x then return print("X coordinate is not a number.") end
  local y = tonumber(args[2])
  if not y then return print("Y coordinate is not a number.") end

  if not Grid:inside(x, y) then
    return print("Background out of bounds.")
  end
  local c = Grid:getBackground(x, y) or Cell("empty", 0, {})

  print("[ Background ]")
  print("X: " .. x)
  print("Y: " .. y)
  print("ID: " .. c.id)
  print("ROT: " .. c.rot)
end)

local cellConfig = {}
local creationListeners = {}

function AddPostCellCreationListener(listener)
  table.insert(creationListeners, listener)
end

Cells = {}

function CreateCell(id, config)
  table.insert(Cells, id)
  cellConfig[id] = config

  for _, listener in ipairs(creationListeners) do
    listener(id, config)
  end
end

BindCommand("list-cells", function()
  print("[ Cells ]")
  for _, id in ipairs(Cells) do
    print(id)
  end
end)

function GetCellConfig(id)
  return cellConfig[id] or {}
end

function ToSide(dir, rot)
  return (dir - rot + 2) % 4
end

function RotateRaw(cell, amount)
  ---@diagnostic disable-next-line: undefined-field
  if Grid.rotate then return Grid:rotate(cell, amount) end
  cell.rot = (cell.rot + amount) % 4
end

function RotateCell(x, y, amount, dir)
  local cell = Grid:get(x, y)
  if not cell then return end
  local config = GetCellConfig(cell.id)
  if type(config.canRotate) == "function" then
    if not config.canRotate(cell, amount, dir) then return end
  end
  RotateRaw(cell, amount)
end

function FixCell(cell, x, y)
  cell.x = x
  cell.y = y

  ---@param dir number
  ---@param force number
  ---@param options table
  cell.push = function(self, dir, force, options) Push(self.x, self.y, dir, force, options) end

  return cell
end
