---@class DynamicGrid
---@field cells table
---@field bg table
---@field type string
local _DynamicGrid = {}
_DynamicGrid.__index = _DynamicGrid

function _DynamicGrid:create()
  self.cells = {}
  self.bg = {}
end

---@param x number
---@param y number
function _DynamicGrid:inside(x, y)
  return true
end

---@param x number
---@param y number
---@param cell Cell
function _DynamicGrid:set(x, y, cell)
  self.cells[tostring(x) .. " " .. tostring(y)] = FixCell(cell, x, y)
end

---@param x number
---@param y number
function _DynamicGrid:at(x, y)
  return self:get(x, y)
end

---@param x number
---@param y number
function _DynamicGrid:indir(x, y, dir, amount)
  amount = amount or 1

  if dir == 0 then return x + amount, y end
  if dir == 1 then return x, y + amount end
  if dir == 2 then return x - amount, y end
  if dir == 3 then return x, y - amount end
end

---@param x number
---@param y number
function _DynamicGrid:get(x, y)
  return FixCell(self.cells[tostring(x) .. " " .. tostring(y)] or Cell("empty", 0, {}), x, y)
end

---@param x number
---@param y number
function _DynamicGrid:getBackground(x, y)
  return self.bg[tostring(x) .. " " .. tostring(y)] or Cell("empty", 0, {})
end

---@param x number
---@param y number
---@param cell Cell
function _DynamicGrid:setBackground(x, y, cell)
  self.bg[tostring(x) .. " " .. tostring(y)] = cell
end

function SortedPairs(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys + 1] = k end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys
  if order then
    table.sort(keys, function(a, b) return order(t, a, b) end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[ keys[i] ]
    end
  end
end

---@param callback function
---@param alignment GridAlignment
function _DynamicGrid:loopGrid(callback, alignment)
  alignment = alignment or 2

  for posKey, cell in SortedPairs(self.cells, function(table, pos1, pos2)
    local pos1Split = SplitStr(pos1, " ")
    local x1 = tonumber(pos1Split[1])
    local y1 = tonumber(pos1Split[2])

    local pos2Split = SplitStr(pos2, " ")
    local x2 = tonumber(pos2Split[1])
    local y2 = tonumber(pos2Split[2])

    if alignment == 2 then
      return (x2 > x1)
    elseif alignment == 0 then
      return (x1 > x2)
    elseif alignment == 1 then
      return (y1 > y2)
    elseif alignment == 3 then
      return (y2 > y1)
    end
  end) do
    local posSplit = SplitStr(posKey, " ")
    local x = tonumber(posSplit[1])
    local y = tonumber(posSplit[2])
    callback(x, y)
  end
end

function _DynamicGrid:new()
  local c = setmetatable({
    cells = {},
    bg = {},
    type = "dynamci",
  }, self)

  c:create()

  return c
end

function _DynamicGrid:copy()
  local g = _DynamicGrid:new()
  g.bg = table.copy(self.bg)
  g.cells = table.copy(self.cells)
end

function DynamicGrid()
  return _DynamicGrid:new()
end

BindCommand("create-dynamic-grid", function(args)
  Grid = DynamicGrid()
  print("Created an infinite grid.")
  InitialGrid = Grid:copy()
end)
