---@class DynamicGrid
---@field cells table
---@field bg table
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
  self.cells[tostring(x) .. " " .. tostring(y)] = cell
end

---@param x number
---@param y number
function _DynamicGrid:at(x, y)
  return self:get(x, y)
end

---@param x number
---@param y number
function _DynamicGrid:get(x, y)
  return self.cells[tostring(x) .. " " .. tostring(y)] or Cell("empty", 0, {})
end

---@param x number
---@param y number
function _DynamicGrid:getBackground(x, y)
  if not self:inside(x, y) then return Cell("empty", 0, {}) end
  return self.bg[tostring(x) .. " " .. tostring(y)]
end

---@param x number
---@param y number
---@param cell Cell
function _DynamicGrid:setBackground(x, y, cell)
  if not self:inside(x, y) then return end
  self.bg[tostring(x) .. " " .. tostring(y)] = cell
end

---@param callback function
---@param alignment GridAlignment
function _DynamicGrid:loopGrid(callback, alignment)
  alignment = alignment or 2

  local pos = {}

  for posKey, cell in pairs(self.cells) do
    table.insert(pos, posKey)
  end

  table.sort(pos, function(pos1, pos2)
    local pos1Split = SplitStr(pos1, " ")
    local x1 = tonumber(pos1Split[1])
    local y1 = tonumber(pos1Split[2])

    local pos2Split = SplitStr(pos2, " ")
    local x2 = tonumber(pos2Split[1])
    local y2 = tonumber(pos2Split[2])

    if alignment == 2 then
      return (y1 < y2 or x1 < x2)
    elseif alignment == 0 then
      return (y1 < y2 or x1 > x2)
    elseif alignment == 1 then
      return (x1 < x2 or y1 > y2)
    elseif alignment == 3 then
      return (x1 < x2 or y1 < y2)
    end
  end)

  for _, posKey in ipairs(pos) do
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
  }, self)

  c:create()

  return c
end

function DynamicGrid()
  return _DynamicGrid:new()
end

BindCommand("create-dynamic-grid", function(args)
  Grid = DynamicGrid()
  print("Created an infinite grid.")
end)
