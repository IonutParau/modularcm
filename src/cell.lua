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
